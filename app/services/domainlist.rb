class DomainList
  def write!(file)
    File.open(file, 'w') do |fh|
      fh.write domainlist
    end
  end

  def domainlist
    domains.join("\n")
  end

  private

  def domains
    @domains ||= Domain.map(:domain)
  end
end
