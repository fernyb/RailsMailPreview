#
#  FBDatabaseBase.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/20/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#

class FBDatabaseBase
  def self.support_path
    bundleName = NSBundle.mainBundle.objectForInfoDictionaryKey("CFBundleName")
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
    sql_path = NSBundle.mainBundle.pathForResource("create_message_table", ofType:"sql")
    error = Pointer.new("@")
    sql = NSString.stringWithContentsOfFile(sql_path, encoding:NSUTF8StringEncoding, error:error)
    if error[0].nil?
      puts sql
      @db.execute(sql)
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
    code = %Q{
      def #{name.to_s}=(val)
        instance_variable_set("@_#{name.to_s}_field".to_sym, val)
      end

      def #{name.to_s}
        instance_variable_get("@_#{name.to_s}_field".to_sym)
      end
    }
    class_eval(code)
  end

  def fields
    instance_variables.select {|ivar| ivar =~ /_([a-z_]+)_field$/i }.map {|var|
      var =~ /_([a-z_]+)_field/i
      {$1.to_s => instance_variable_get(var)}
    }.inject({}) {|k,val| k.merge!(val) }
  end

  def insert_sql
   keys = fields.keys
   values = keys.map {|k| "'#{CGI.escape(fields[k])}'" }
   keys   = keys.map {|k| "`#{k}`" }
   "INSERT INTO `#{self.class.table_name}` (#{keys.join(', ')}) VALUES (#{values.join(', ')})"
  end

  def save
    self.class.db.execute(insert_sql)
  end

  def initialize
  end
end
