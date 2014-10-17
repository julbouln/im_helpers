# coding: utf-8
require 'im_helpers'
require 'im_helpers/ext/string'
require 'im_helpers/ext/number'
require 'im_helpers/ext/date'

require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

class Test::Unit::TestCase
end

class TestImOnix < Test::Unit::TestCase
  context "extensions" do
    setup do
    end

    should "strip html" do
      assert_equal "Hello World","<p><em>Hello</em> <strong>World</strong></p>".strip_html
    end

    should "strip spaces" do
      assert_equal "Hello World","Hello   World".strip_spaces
    end

    should "prec float" do
      assert_equal 1.23,1.23456789.prec(2)
    end


  end
  context "language" do
    setup do
    end

    should "french" do
      assert_equal "Français",ImHelpers::Language.find("fre").native_name
    end
  end

  context "territories" do
    setup do

    end

    should "currency for france" do
      assert_equal "EUR",ImHelpers::Territories.currency_for_country("FR")
    end

    should "country with CAD" do
      assert_equal ["CA"],ImHelpers::Territories.countries_with_currency("CAD")
    end

  end
end