# == Schema Information
#
# Table name: comments
#
#  id   :bigint           not null, primary key
#  body :text
#
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article
end
