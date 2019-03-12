class Auth
  class << self
    attr_accessor :passwd_file

    def ok?(user, pass)
      new(File.new(passwd_file)).authenticate(user,pass)
    end

  end

  attr_accessor :passwd_file

  def initialize(file)
    self.passwd_file = file
  end

  def authenticate(user, pass)
      any_line? do |line|
        (passwd_user, salt, passwd_hash) = line.split(':')

        next unless user == passwd_user
        check_pass(passwd_hash, salt, pass) 
      end
  end

  def check_pass(expected, salt, entered_pass)
    expected == digest("#{salt}:#{entered_pass}")
  end

  def any_line?
    passwd_file.each_line do |line|
      if yield line.chomp
        return true
      end
    end

    false
  end

  def digest(input)
    Digest::SHA2.new(256).hexdigest input
  end
end
