class Api::ConversationsController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :set_current_user, only: [:index, :send_sms, :clear_conversation, :message_history]
	before_action :set_conversation, only: [:message_history, :send_sms, :clear_conversation]

	#GET: /api/conversations
	def index 
		@conversations = @current_user.conversations
		render json: {
				sucess: :true,
				message: 'data_found',
				data: @conversations.map do |conversation|
					{ 
						id: conversation.id,
						contact_name: conversation.users.reject{|x| x.id == @current_user.id}.map(&:name).join(',')
					}
				end
		}
	end

	#GET: /api/conversations/:conversation_id/message_history
	def message_history
		last_history = @conversation.clear_conversation_histories.where(user_id: @current_user.id).last 
		@messages_history = if last_history.present?
													@conversation.messages.where(created_at: last_history.created_at..)
												else
													@conversation.messages
												end
		render json: {
									sucess: :true,	
									message: 'data_found',
									data: @messages_history.map do |message|
										{ 
											id: message.id,
											sender: { id: message.user.id,
																name: message.user.name
															},
											content: message.content,
											created_at: message.created_at.strftime("%m/%d/%Y, %H:%M:%S")
										}
									end
		} 
	end
	
	# Post: /api/conversations/:conversation_id/send_sms
	def send_sms
		@conversation.messages.create(content: params[:sms_content], user_id: @current_user.id)
		render json:  {
									 sucess: :true,
									 message: "sent successfully #{@conversation.users.reject{|x| x.id == @current_user.id}.map(&:name).join(',')}"
									}
	end

	# Get /api/conversations/:conversation_id/clear_conversation
	def  clear_conversation
		if @conversation.users.include?(@current_user)
			@conversation.clear_conversation_histories.create(user_id: @current_user.id)
 			render json: {sucess: :true, message: 'Conversation has been cleared successfully.'}
		else
			render json: {sucess: :false, message: 'User not authorized to clear this conversation'}
		end
	end
	
	private

	def set_current_user
		@current_user = User.find(params[:current_user_id])
	end
	
	def set_conversation
		@conversation = Conversation.find(params[:conversation_id])
	end

end