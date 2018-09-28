class Auth
  class << self
    attr_accessor :passwd_file

    def ok?(user,pass)
      new(passwd_file).authenticate(user,pass)
    end

  end

  attr_accessor :passwd_file

  def initialize(file)
    passwd_file = passwd_file
  end

  def authenticate(user, pass)
      any_line? do |line|
        (passwd_user, salt, passwd_hash) = line.split(':')

        next unless user == passwd_user
        check_pass(passwd_hash, salt, pass) 
      end
  end

  def check_pass(expected, salt, entered)
    expected == digest("#{salt}:#{pass}")
  end

  def any_line?(file, &block)
    file.each_line do |line|
      if block(line)
        return true
      end
    end

    false
  end

  def digest(input)
    Digest::SHA2.new(256).hexdigest input
  end
end
