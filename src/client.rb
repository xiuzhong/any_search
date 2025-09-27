class Client < Struct.new(:id, :full_name, :email)
  def initialize(id, full_name, email)
    email = email&.strip&.downcase
    super(id, full_name, email)

    validate!
  end

  private

  def validate!
    [:id, :full_name, :email].each do |attr|
      fail(ArgumentError, "#{attr} is invalid") if send(attr).nil?
    end

    [:full_name, :email].each do |attr|
      fail(ArgumentError, "#{attr} must be a string") unless send(attr).is_a?(String)
      fail(ArgumentError, "#{attr} cannot be empty") if send(attr).strip.empty?
    end
  end
end