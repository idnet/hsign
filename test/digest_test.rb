require 'test_helper'
require 'hsign/digest'

class DigestTest < Test::Unit::TestCase

  def setup
    @ip = "127.0.0.1"
    @params = {'key1' => 'value1', 'key2' => 'value2'}
    @hsign = HSign::Digest.new("secret", @ip)
  end

  test "changing ip" do
    sig = @hsign.sign(@params)
    other_hsign = HSign::Digest.new("secret", "127.0.1.1")
    sig1 = other_hsign.sign(@params)
    assert_not_equal sig, sig1
  end

  test "changing parameter" do
    params = @params.dup
    params['key1'] = 'different'
    sig = @hsign.sign(@params)
    sig1 = @hsign.sign(params)
    assert_not_equal sig, sig1
  end

  test "changing secret" do
    other_hsign = HSign::Digest.new("anothersecret", @ip)
    sig = @hsign.sign(@params)
    sig1 = other_hsign.sign(@params)
    assert_not_equal sig, sig1
  end

  test "verify signature" do
    sig = @hsign.sign(@params)
    other_hsign = HSign::Digest.new("secret", @ip)

    assert_nil @params[@hsign.hmac_key]
    params = @params.dup
    params[@hsign.hmac_key] = sig
    assert other_hsign.verify?(params)

    # let test another hmac
    other_hsign = HSign::Digest.new("secret", @ip)
    p = params.dup
    params[@hsign.hmac_key] = sig + "altered"
    assert !other_hsign.verify?(p)
  end

  test "nested parameters" do
    params = {prefill: {key1: 'hello', key2: 'world'}}
    equivalent_params = {'prefill[key1]' => 'hello', 'prefill[key2]' => 'world'}
    assert_equal @hsign.sign(params), @hsign.sign(equivalent_params)

    params = {prefill: {ns: {name: 'hello'}, key2: 'world'}, terra: 'incognita'}
    equivalent_params = {'prefill[ns][name]' => 'hello', 'prefill[key2]' => 'world', 'terra' => 'incognita'}
    assert_equal @hsign.sign(params), @hsign.sign(equivalent_params)
  end

  test "non string nested parameters" do
    params = { prefill: {key1: 1, key2: 2} }
    equivalent_params = {'prefill[key1]' => '1', 'prefill[key2]' => '2'}
    assert_equal @hsign.sign(params), @hsign.sign(equivalent_params)
  end

  test "agregate signed params hash" do
    params = { key1: 1, key2: 2 }
    equivalent_params = { 'key1' => '1', 'key2' => '2' }
    @hsign.sign(params)
    assert_equal @hsign.params, equivalent_params.merge('_hmac' => @hsign.sign(params))
  end

  test "verify string and non string values" do
    params = { key1: 1, key2: 2 }
    equivalent_params = { 'key1' => '1', 'key2' => '2', '_hmac' => @hsign.sign(params) }
    assert @hsign.verify?(equivalent_params)
  end
end
