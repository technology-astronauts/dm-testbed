require 'spec_helper'

require 'db/models'

describe 'issue #219' do

  describe 'union of all posts and user posts' do
    let!(:user) { DB::I219::User.create }
    before(:each) do
      p1 = DB::I219::Post.create name: "p1", user: user
      p2 = DB::I219::Post.create name: "p2"
      p3 = DB::I219::Post.create name: "p3"
    end

    it 'should yield [1,nil,nil] when starting with all posts' do
      (DB::I219::Post.all | user.posts).collect { |post| post.user_id }.should == [user.id,nil,nil]
    end
    it 'should yield [1,nil,nil] when starting with user posts' do
      (user.posts | DB::I219::Post.all).collect { |post| post.user_id }.should == [user.id,nil,nil]     
    end
    it 'should still behave properly with respect to inversely setting ids' do
      p4 = DB::I219::Post.create(name: 'p4')
      user.posts << p4

      p4.user_id.should == user.id
    end
  end
end