#
#  FBDatabaseBase.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/20/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#

class FBDatabaseBase
  def self.support_path
    # bundleName = NSBundle.mainBundle.objectForInfoDictionaryKey("CFBundleName")
    bundleName = "RailsMailPreview"
    databasePath = "~/Library/Application Support/#{bundleName}".stringByExpandingTildeInPath
  end

  def self.create_support_path
    if !File.exists?(support_path)
      error = Pointer.new("@")
      fm = NSFileManager.defaultManager
      fm.createDirectoryAtPath(support_path, withIntermediateDirectories:YES, attributes:nil, error:error)
      if !error[0].nil?
        NSLog("Error Trying to create Application Support / #{bundleName}")
        abort()
      end
    end
  end

  def self.initialize
    create_support_path
    databaseFilePath = "#{support_path}/database.db"

    load_sql = false
    if !File.exists?(databaseFilePath)
      File.open(databaseFilePath, "w+")
      load_sql = true
    end

    @db = SQLite3::Database.new(databaseFilePath)
    self.table_name = "#{self.name}s"

    load_default_sql if load_sql
  end

  def self.load_default_sql
    sql_path = "#{RESOURCE_PATH}/create_message_table.sql"
    error = Pointer.new("@")
    sql = NSString.stringWithContentsOfFile(sql_path, encoding:NSUTF8StringEncoding, error:error)
    if error[0].nil?
      @db.execute_batch(sql)
    else
      NSLog("*** Error trying to get contents of file: #{sql_path}")
    end
  end

  def self.db
    @db
  end

  def self.table_name=(name)
    @table_name = name.downcase
  end

  def self.table_name
    @table_name
  end

  def self.field(name, options={})
    class_eval(%Q{
      def #{name.to_s}=(val)
        instance_variable_set("@_#{name.to_s}_field".to_sym, val)
      end

      def #{name.to_s}
        instance_variable_get("@_#{name.to_s}_field".to_sym)
      end

      instance_variable_set("@_#{name.to_s}_opts".to_sym, #{options})
    })
  end

  def self.has_many(name)
    class_eval(%Q{
      def #{name.to_s}
        var = instance_variable_get("@_#{name.to_s}_has_many".to_sym)
        if var.nil?
          instance_variable_set("@_#{name.to_s}_has_many".to_sym, [])
          instance_variable_get("@_#{name.to_s}_has_many".to_sym)
        else
          var
        end
      end
    })
  end

  def self.belongs_to(name)
    class_eval(%Q{
      def #{name.to_s}
      end
    })
  end

  def fields
    instance_variables.select {|ivar| ivar =~ /_([a-z_]+)_field$/i }.map {|var|
      var =~ /_([a-z_]+)_field/i
      {$1.to_s => instance_variable_get(var)}
    }.inject({}) {|k,val| k.merge!(val) }
  end

  def insert_sql
   keys = fields.keys
   values = keys.map do |k| 
     v = fields[k]

     opts = self.class.instance_variable_get("@_#{k}_opts".to_sym)
     if opts
       if opts[:on_save]
         v = self.send(opts[:on_save])
       end
       if opts[:type] != 'Integer'
         v = v.to_s
       end
     end
     v
   end

   keys = keys.map {|k| "`#{k}`" }
   placehoders = ("?, " * values.size).to_s[0..-3]

    sql = "INSERT INTO `#{self.class.table_name}` (#{keys.join(', ')}) VALUES (#{placehoders})"
    self.class.db.execute(sql, *values)
  end

  def save_insert_sql
    self.insert_sql
    results = self.class.db.execute("SELECT last_insert_rowid() FROM `#{self.class.table_name}` LIMIT 1")
    self.id = results.flatten.first
  end

  def save_has_many
     instance_variables.select {|ivar| ivar =~ /_has_many$/ }.each do |var|
       var =~ /_([a-z_]+)_has_many$/i
        items = instance_variable_get(var)
        items.each do |item|
          item.send("#{self.class.table_name[0..-2]}_id=", self.id)
          item.save
        end
     end
  end

  def save
    save_insert_sql
    save_has_many
    self.id.to_s =~ /^([0-9]+)$/ ? true : false
  end

  def self.columns
    if @columns.nil?
      results  = db.execute("PRAGMA table_info(#{table_name})")
      @columns = results.map {|r| r[1] }
    end
    @columns
  end

  def self.map_results(results)
    fields = columns
    results.map {|r|
      mapped_fields = Hash[*fields.zip(r).flatten]

      item = new
      mapped_fields.keys.each do |k|
        if item.respond_to?("#{k}=")
          item.send("#{k}=", mapped_fields[k])
        end
      end
      item
    }
  end

  def self.all
    results = db.execute("SELECT * FROM `#{table_name}`")
    map_results(results)
  end

  def self.first
    results = db.execute("SELECT * FROM `#{table_name}` LIMIT 1")
    map_results(results).first
  end

  def self.find_by_id(id)
    results = db.execute("SELECT * FROM `#{table_name}` WHERE id = #{id} LIMIT 1")
    map_results(results).first
  end

  def self.where(conditions)
    if conditions
      where = conditions.shift
      puts conditions.inspect
      results = db.execute("SELECT * FROM `#{table_name}` WHERE #{where}", *conditions)
      map_results(results)
    end
  end

  def initialize
  end
end
