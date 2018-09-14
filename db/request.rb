class Request < Sequel::Model
  dataset_module do
    def allowed
      exclude allowed_at: nil
    end

    def denied
      exclude denied_at: nil
    end

    def pending
      where allowed_at: nil, denied_at: nil
    end
  end

  def allowed?
    !allowed_at.nil?
  end

  def denied?
    !denied_at.nil?
  end

  def pending?
    denied_at.nil? && allowed_at.nil?
  end

  def validate
    super
    if pending?
      if Request.pending.where(url: url).exclude(id: id).count > 0
        errors.add(:url, 'there cannot be more than one pending request for the same URL')
      end
    end
  end
end
