# == Schema Information
#
# Table name: likes
#
#  id :bigint           not null, primary key
#
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :article
end
