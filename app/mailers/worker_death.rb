class WorkerDeath < ActionMailer::Base

    default :from => BarcodeWarehouse::Application.config.worker_death_from,
            :to => BarcodeWarehouse::Application.config.worker_death_to,
            :subject => "[#{Rails.env.upcase}] BArcode Warehouse worker death"

  def failure(exception)
    @exception = exception
    mail( )
  end

end
