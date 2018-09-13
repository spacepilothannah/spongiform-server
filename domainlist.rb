class DomainList
  attr_reader :file

  def initialize(file)
    @file = file
  end

  def write!
    File.open(file) do |fh|
      fh.write domainlist
    end
  end

  private

  def domainlist
    domains.join("\n")
  end

  def domains
    @domains ||= Domain.where(allowed: true).map(:domain)
  end
end
