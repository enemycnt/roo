# encoding: utf-8
require 'spec_helper'
require 'roo/excelx/formatted_scan'

describe FormattedScan do

  before :each do
    @formatted_scan = FormattedScan.new("[$¥-804]#,##0.0", 800.45)
  end

  describe "#new" do
    it "takes string and value params and returns a FormattedScan object" do
      expect(@formatted_scan).to be_an_instance_of FormattedScan
    end
  end

  describe 'to_s', :string do
    it "takes string and value params and returns a FormattedScan object" do
      expect(@formatted_scan.to_s).to eq("¥800.5")
    end
  end

  describe 'replace_parts' do
    it 'process data with format code with decimal' do
      expect(@formatted_scan.replace_parts("[$¥-804]#,##0.0", 800.5)).to eq("¥800.5")
    end

    it 'process data with format code with decimal' do
      expect(@formatted_scan.replace_parts("[$¥-804]#,##0.00", 800.45)).to eq("¥800.45")
    end

    it 'process data with format code with decimal and money symbol in the end' do
      expect(@formatted_scan.replace_parts("#,##0.00[$¥-804]", 800.45)).to eq("800.45¥")
    end

    it 'process data with format code with int' do
      expect(@formatted_scan.replace_parts("[$¥-804]#,##0", 800.5)).to eq("¥801")
    end

    it 'process data with format code with money code' do
      expect(@formatted_scan.replace_parts("#,##0\\ \"RUB\"", 800.5)).to eq("801 RUB")
    end

    it 'process data with format code with money code with CA$' do
      expect(@formatted_scan.replace_parts("#,##0\\ \"CA$\"", 800.5)).to eq("801 CA$")
    end

    it 'process data with format code with money code with руб' do
      expect(@formatted_scan.replace_parts("#,##0\\ \"руб\"", 800.5)).to eq("801 руб")
    end

    it 'process data with format code with money code with руб.' do
      expect(@formatted_scan.replace_parts("#,##0\р\у\б\.", 800.5)).to eq("801руб.")
    end

    it 'process data with format code with money code with тенге' do
      expect(@formatted_scan.replace_parts("#,##0\\ \"тенге\"", 800.44)).to eq("800 тенге")
    end

    it 'process data with format code with money code with $ in the end' do
      expect(@formatted_scan.replace_parts("#,##0.0\\ [$$-804]", 800.44)).to eq("800.4 $")
    end

    it 'process data with format code with money code with € in the beginning' do
      expect(@formatted_scan.replace_parts("[$€-2]\ #,##0.00", 800.44)).to eq("€ 800.44")
    end

    it 'process data with format code with money code with тенге' do
      expect(@formatted_scan.replace_parts("#,##0", 800.55)).to eq("801")
    end

    it 'process data with "[Red]" in format' do
      expect(@formatted_scan.replace_parts("[$€-2]\ #,##0.00;[Red][$€-2]\ #,##0.00", 100.00)).to eq("€ 100.0")
    end

    it 'process negative data with format code with money code with €' do
      expect(@formatted_scan.replace_parts("[$€-2]\ #,##0.00", -800.44)).to eq("-€ 800.44")
    end

    it 'process negative data' do
      expect(@formatted_scan.replace_parts("#,##0", -800.55)).to eq("-801")
    end

    it 'process precent data' do
      expect(@formatted_scan.replace_parts("0%", 0.95)).to eq("95%")
    end

    it 'process fractional precent ' do
      expect(@formatted_scan.replace_parts("0.0%", 0.095)).to eq("9.5%")
    end

    it 'process fractional precent ' do
      expect(@formatted_scan.replace_parts("0.00%", 0.0095)).to eq("0.95%")
    end

  end

  describe 'rounded_num' do
    it 'returns rounded decimal' do
      expect(@formatted_scan.rounded_num("0.0", 800.45)).to eq(800.5)
    end

    it 'returns rounded decimal to 2 digit' do
      expect(@formatted_scan.rounded_num("0.00", 800.45)).to eq(800.45)
    end
  end

  describe 'get_num', :rounded do
    it 'returns get decimal or int' do
      expect(@formatted_scan.get_num("[$¥-804]#,##0.0", 800.45)).to eq(800.5)
    end

    it 'returns rounded int' do
      expect(@formatted_scan.get_num("[$¥-804]#,##0", 800.45)).to eq(800)
    end
  end

end