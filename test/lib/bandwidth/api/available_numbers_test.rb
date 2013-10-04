require_relative '../../../test_helper'

describe Bandwidth::API::AvailableNumbers do
  before do
    @bandwidth = Bandwidth::StubbedConnection.new 'user_id', 'token', 'secret'
  end

  it "returns a list of available local numbers" do
    @bandwidth.stub.get('/availableNumbers/local') {[200, {}, <<-JSON
      [
        {
          "number": "+19192972390",
          "nationalNumber": "(919) 297-2390",
          "patternMatch": "          2 9 ",
          "city": "CARY",
          "lata": "426",
          "rateCenter": "CARY",
          "state": "NC"
        },
        {
          "number": "+19192972393",
          "nationalNumber": "(919) 297-2393",
          "patternMatch": "          2 9 ",
          "city": "CARY",
          "lata": "426",
          "rateCenter": "CARY",
          "state": "NC"
        }
      ]
      JSON
    ]}

    numbers = @bandwidth.available_numbers
    assert_equal 2, numbers.size

    number = numbers.first
    assert_equal "+19192972390", number.number
    assert_equal "(919) 297-2390", number.national_number
    assert_equal "          2 9 ", number.pattern_match
    assert_equal "CARY", number.city
    assert_equal "NC", number.state
  end

  it "returns a list of available toll free numbers" do
    @bandwidth.stub.get('/availableNumbers/tollFree') {[200, {}, <<-JSON
      [
        {
          "number":"+18557626967",
          "nationalNumber":"(855) 762-6967",
          "patternMatch":"        2  9  ",
          "price":"2.00"
        },
        {
          "number":"+18557712996",
          "nationalNumber":"(855) 771-2996",
          "patternMatch":"          2 9 ",
          "price":"2.00"
        }
      ]
      JSON
    ]}

    numbers = @bandwidth.available_toll_free_numbers
    assert_equal 2, numbers.size

    number = numbers.first
    assert_equal "+18557626967", number.number
    assert_equal "(855) 762-6967", number.national_number
    assert_equal "        2  9  ", number.pattern_match
    assert_equal 2.00, number.price
  end
end
