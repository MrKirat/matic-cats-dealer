# frozen_string_literal: true

RSpec::Matchers.matcher :be_success_monad do |expected|
  match do |actual|
    expect(actual).to be_success
    expect(actual).to have_attributes(success: expected)
  end
end

RSpec::Matchers.matcher :be_failure_monad do |expected|
  match do |actual|
    expect(actual).to be_failure
    expect(actual).to have_attributes(failure: expected)
  end
end
