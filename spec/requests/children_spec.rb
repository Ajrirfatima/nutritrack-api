require "rails_helper"

RSpec.describe "Api::V1::Children", type: :request do
  let(:user) { create(:user) }
  let(:headers) { user.create_new_auth_token }

  describe "GET /api/v1/children" do
    let!(:children) { create_list(:child, 3, user: user) }

    it "returns all children for current user" do
      get "/api/v1/children", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["children"].length).to eq(3)
    end

    it "requires authentication" do
      get "/api/v1/children"
      expect(response).to have_http_status(:unauthorized)
    end

    it "filters by dietary restriction" do
      create(:child, user: user, dietary_restriction: "vegan")
      get "/api/v1/children", params: { dietary_restriction: "vegan" }, headers: headers
      body = JSON.parse(response.body)
      expect(body["children"].all? { |c| c["dietary_restriction"] == "vegan" }).to be true
    end
  end

  describe "POST /api/v1/children" do
    let(:valid_params) do
      { child: { name: "Sara", age: 5, dietary_restriction: "none" } }
    end

    it "creates a new child" do
      expect {
        post "/api/v1/children", params: valid_params, headers: headers
      }.to change(Child, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "returns errors for invalid params" do
      post "/api/v1/children", params: { child: { name: "" } }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to have_key("errors")
    end
  end

  describe "PATCH /api/v1/children/:id" do
    let(:child) { create(:child, user: user) }

    it "updates the child" do
      patch "/api/v1/children/#{child.id}",
            params: { child: { name: "New Name" } },
            headers: headers
      expect(response).to have_http_status(:ok)
      expect(child.reload.name).to eq("New Name")
    end

    it "cannot update another user's child" do
      other_child = create(:child)
      patch "/api/v1/children/#{other_child.id}",
            params: { child: { name: "Hacked" } },
            headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /api/v1/children/:id" do
    let!(:child) { create(:child, user: user) }

    it "deletes the child" do
      expect {
        delete "/api/v1/children/#{child.id}", headers: headers
      }.to change(Child, :count).by(-1)
      expect(response).to have_http_status(:ok)
    end
  end
end
