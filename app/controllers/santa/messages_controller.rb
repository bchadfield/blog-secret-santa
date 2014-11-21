class Santa::MessagesController < Santa::SantaController

	def new
		@message = Message.new
	end

	def create
		@message = Message.new(message_params).deliver
		if @message.errors.full_messages.present?
			render 'new'
		else
			flash[:success] = "Message was sent"
			redirect_to santa_root_path
		end
	end

	private

		def message_params
			params.require(:message).permit(:to, :subject, :body, :template)
		end
end