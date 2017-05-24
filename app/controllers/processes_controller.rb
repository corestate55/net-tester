class ProcessesController < ApplicationController

  # GET /processes
  def index
    processes = NetTester::Process.all.values
    render json: processes, status: :ok
  end

  # GET /processes/1
  def show
    id = params[:id]
    result = NetTester::Process.find(id)
    code = :ok
    if result.nil? then
      result = {error: "no such process: #{id}"}
      code = :not_found
    end
    render json: result, status: code
  end

  # POST /processes
  def create
    host_name = process_params[:host_name]
    if Phut::Netns.find_by(name: host_name).nil? then
      result = {error: "no such host: #{host_name}"}
      render json: result, status: :bad_request
    else
      command = process_params[:command]
      process = NetTester::Process.new(host_name: host_name)
      process.exec(command)
      render json: process, status: :ok
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def process_params
      params.fetch(:process, {})
    end
end
