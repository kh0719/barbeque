class JobRetry < ApplicationRecord
  belongs_to :job_execution
  has_one :job_definition, through: :job_execution
  has_one :app, through: :job_definition
  has_one :slack_notification, through: :job_execution

  enum status: {
    pending: 0,
    success: 1,
    failed:  2,
    retried: 3,
  }

  # @return [Hash] - A hash created by `JobExecutor::Retry#log_result`
  def execution_log
    @execution_log ||= JobExecutor::Storage.load(execution: self)
  end

  def to_resource
    Api::JobRetryResource.new(self)
  end
end
