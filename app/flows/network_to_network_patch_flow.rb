# coding: utf-8
# frozen_string_literal: true

class NetworkToNetworkPatchFlow < ActiveFlow::Base
  def self.create(physical_switch_dpid:, source_port:, destination_port:)
    send_flow_mod_add(physical_switch_dpid,
                      match: Match.new(in_port: source_port),
                      actions: SendOutPort.new(destination_port))
  end

  def self.destroy(physical_switch_dpid:, source_port:, destination_port:)
    send_flow_mod_delete(physical_switch_dpid,
                         match: Match.new(in_port: source_port),
                         out_port: destination_port)
  end
end
