# coding: utf-8
# frozen_string_literal: true

Given(/^NetTester 物理スイッチとテスト対象ホストを次のように接続:$/) do |table|
  table.hashes.each do |each|
    pport_id = each['Physical Port'].to_i
    pport_name = "pport#{pport_id}"
    host_id = each['Host']
    host_name = "host#{host_id}"
    link = Phut::Link.create(host_name, pport_name)
    p "link #{host_name}-#{pport_name}, device=#{link.names}, up?=#{link.up?}"
    Phut::Vhost.create(name: host_name,
                       ip_address: "192.168.0.#{host_id}",
                       mac_address: "00:ba:dc:ab:1e:#{sprintf('%02x', host_id)}",
                       device: link.device(host_name))
    @physical_test_switch.add_numbered_port(pport_id, link.device(pport_name))
  end
end

When(/^(\d+) sec wait$/) do |sec|
  1.upto(3) do |each|
    host_name = "host#{each}"
    host = Phut::Vhost.find_by(name: host_name)
    p "#{host_name}: run?=#{host.running?}, ip=#{host.ip_address}, mac=#{host.mac_address}, device=#{host.device}"
  end
  p 'send packet from host2 to host3'
  NetTester.send_packet('host2', 'host3')
  p "sleep #{sec}sec"
  sleep sec.to_i
end

When(/^次のNW機器間パッチを追加:$/) do |table|
  table.hashes.each do |each|
    pport_a = each['Physical Port A'].to_i
    pport_b = each['Physical Port B'].to_i
    NetTester.add_p2p(pport_a, pport_b)
  end
end