# frozen_string_literal: true

describe PaymentRequest do
  describe 'db columns' do
    it { is_expected.to have_db_column(:amount_in_cents).with_options(null: false) }
    it { is_expected.to have_db_column(:currency).with_options(null: false) }
    it { is_expected.to have_db_column(:description) }
  end

  describe 'validations' do
    subject { create(:payment_request) }

    it { is_expected.to validate_presence_of(:amount_in_cents) }
    it { is_expected.to validate_presence_of(:currency) }
    it { is_expected.to validate_inclusion_of(:currency).in_array(Currencies::ALLOWED_CURRENCIES)}
  end

  describe 'enums' do
    subject { create(:payment_request) }

    it { is_expected.to define_enum_for(:status).with_values([:pending, :accepted, :rejected]) }
  end
end
