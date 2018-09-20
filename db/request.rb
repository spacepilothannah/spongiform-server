class Request < Sequel::Model
  dataset_module do
    def allowed
      exclude allowed_at: nil
    end

    def denied
      exclude denied_at: nil
    end

    def requested
      exclude requested_at: nil
    end

    def pending
      requested
        .where allowed_at: nil, denied_at: nil
    end
  end

  def allowed?
    !allowed_at.nil?
  end

  def denied?
    !denied_at.nil?
  end

  def requested?
    !!requested_at
  end

  def pending?
    requested? && denied_at.nil? && allowed_at.nil?
  end

  def validate
    super
    if pending?
      if Request.pending.where(url: url.to_s).exclude(id: id).count > 0
        errors.add(:url, 'there cannot be more than one pending request for the same URL')
      end
    end
    if allowed? && denied?
      errors.add(:allowed_at, 'a request can only be allowed or denied, not both')
      errors.add(:denied_at, 'a request can only be allowed or denied, not both')
    end
  end
end
