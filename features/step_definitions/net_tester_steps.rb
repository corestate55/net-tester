# coding: utf-8
# frozen_string_literal: true

Given(/^NetTester をオプション "([^"]*)" で起動$/) do |options|
  command = "./bin/net_tester run #{options}"
  system command || railse("#{command} failed")
end

When(/^NetTester で次のパッチを追加:$/) do |table|
  table.hashes.each do |each|
    NetTester::Command.add(@mac_address.fetch(each['Virtual Port'].to_i),
                           each['Virtual Port'].to_i,
                           each['Physical Port'].to_i)
  end

  # $stderr.puts 'dadicool'
  # system "sudo ovs-ofctl dump-flows test_0xdad1c001 -O OpenFlow10"
  # $stderr.puts
  # $stderr.puts 'physw'
  # system "sudo ovs-ofctl dump-flows physw_0x123 -O OpenFlow10"
end

When(/^次のパッチを削除:$/) do |table|
  table.hashes.each do |each|
    NetTester::Command.delete(each['Virtual Port'].to_i, each['Physical Port'].to_i)
  end
end

When(/^各テストホストから次のようにパケットを送信:$/) do |table|
  table.hashes.each do |each|
    NetTester::Command.send_packet("host#{each['Source Host']}", "host#{each['Destination Host']}")
  end
  sleep 1
end

Then(/^各テストホストは次のようにパケットを受信する:$/) do |table|
  table.hashes.each do |each|
    packets_received = NetTester::Command.packets_received("host#{each['Destination Host']}", "host#{each['Source Host']}")
    expect(packets_received).to be 1
  end
end
