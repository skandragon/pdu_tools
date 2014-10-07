# encoding: utf-8
require 'spec_helper'


describe PDUTools::Decoder do
  let(:decoder) { PDUTools::Decoder.new pdu, :ms_to_sc }

  context "7 bit data" do
    let(:pdu) { "0001000C9124910001100000001654747A0E4ACF416110BD3CA783DAE5F93C7C2E03" }
    it "should decode" do
      message_part = decoder.decode
      expect(message_part.body).to eq "This is a test message"
      expect(message_part.address).to eq "+421900100100"
    end
  end

  context "16 bit data" do
    let(:pdu) { "0001000C9124910001100000083E0054006800690073002000690073002000640069006100630072006900740069006300730020013E0161010D0165017E00FD00E100ED00E400FA00F40148" }
    it "should decode" do
      message_part = decoder.decode
      expect(message_part.body).to eq "This is diacritics ľščťžýáíäúôň"
      expect(message_part.address).to eq "+421900100100"
    end
  end

  context "user data header" do
    let(:pdu) { "0041000C912491000110000000A0060804C643020154747A0E4ACF416110BD3CA783DAE5F93C7C2E53D1E939283D078541F4F29C0E6A97E7F3F0B94C45A7E7A0F41C1406D1CB733AA85D9ECFC3E732159D9E83D2735018442FCFE9A076793E0F9FCB54747A0E4ACF416110BD3CA783DAE5F93C7C2E53D1E939283D078541F4F29C0E6A97E7F3F0B94C45A7E7A0F41C1406D1CB733AA85D9ECFC3" }
    it "should decode" do
      message_part = decoder.decode
      expect(message_part.user_data_header).to be_present
      expect(message_part.user_data_header[:parts]).to eq 2
      expect(message_part.user_data_header[:part_number]).to eq 1
    end
  end

  context "GSM PLMNS address type" do
    let(:pdu) { "07912491500030592414D044241354C4C3E5E5F91C00004190200180108095D6B0BEECCE83F4E17558EF4EAF5920B2BB3C0759C36D10485C27D741E4B7BC3E7EDBC3EE32481F9EA7CBEC751E0485324132980D0793C96EB7196E0792C16C38984C76BBCD6E3B900C66C3C164B2DB6D666381C86F71BA2C5F8741319A2CC7CA818A75B90BB47CBBE9E1351D0482E568B4D94D768BDD5C202292092AE2E1F2F27C0E02" }
    it do
      message_part = decoder.decode
      expect(message_part.address).to eq("DHL Express")
      expect(message_part.body).to match /^Vazeny zakaznik/
    end
  end

end