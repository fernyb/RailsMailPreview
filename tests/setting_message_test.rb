require File.dirname(__FILE__) + "/test_helper.rb"

describe 'Setting Message' do
  before do
    FBDatabaseBase.send(:initialize)
    path = "#{CURRENT_PATH}/fixtures/6.email.txt"
    content = File.open(path) {|f| f.read }
    @mail = Mail.new(content)
  end

  describe :setMessage do
    it 'it can set message' do
     message = Message.new
     message.setMessage(@mail)
     message.to.must_equal @mail.to.to_s
    end
  end
end
