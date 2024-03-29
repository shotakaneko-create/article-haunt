class Api::V1::BaseApiController < ApplicationController
  # def current_user
  #   @current_user ||= User.first # ||は項を左から順に判定し、trueを返す
  #   # @current_user =
  #   # @current_user # 最初の時点ではnilなのでfalse
  #   # ||
  #   # User.find_by(id: session[:user_id]) # 中身があればtrueを返す
  #   # 上記が省略して書いたもの（ a = a + 1をa += 1で表すことができるのと同じ理論 )
  # end

  alias_method :current_user, :current_api_v1_user
  alias_method :authenticate_user!, :authenticate_api_v1_user!
  alias_method :user_signed_in?, :api_v1_user_signed_in?
end
