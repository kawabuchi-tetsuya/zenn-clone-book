require 'rails_helper'

RSpec.describe 'Api::V1::Articles', type: :request do
  describe 'GET api/v1/articles' do
    subject { get(api_v1_articles_path(params)) }

    before do
      create_list(:article, 25, status: :published)
      create_list(:article, 8, status: :draft)
    end

    context 'page を params で送信しないとき' do
      let(:params) { nil }

      it '1ページ目のレコードを10件取得できる' do
        subject
        res = JSON.parse(response.body)
        aggregate_failures do
          expect(res.keys).to eq ['articles', 'meta']
          expect(res['articles'].length).to eq 10
          expect(res['articles'][0].keys).to eq ['id', 'title', 'content', 'created_at', 'from_today', 'user']
          expect(res['articles'][0]['user'].keys).to eq ['name']
          expect(res['meta']['current_page']).to eq 1
          expect(res['meta']['total_pages']).to eq 3
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'page を params で送信したとき' do
      let(:params) { { page: 2 } }

      it '該当ページ目のレコードを10件取得できる' do
        subject
        res = JSON.parse(response.body)
        aggregate_failures do
          expect(res.keys).to eq ['articles', 'meta']
          expect(res['articles'].length).to eq 10
          expect(res['articles'][0].keys).to eq ['id', 'title', 'content', 'created_at', 'from_today', 'user']
          expect(res['articles'][0]['user'].keys).to eq ['name']
          expect(res['meta']['current_page']).to eq 2
          expect(res['meta']['total_pages']).to eq 3
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe 'GET api/v1/articles/:id' do
    subject { get(api_v1_article_path(article_id)) }

    let(:article) { create(:article, status:) }

    context 'article_id に対応する article レコードが存在するとき' do
      let(:article_id) { article.id }

      context 'articles レコードのステータスが公開中のとき' do
        let(:status) { :published }

        it '正常にレコードを取得できる' do
          subject
          res = JSON.parse(response.body)
          aggregate_failures do
            expect(res.keys).to eq ['id', 'title', 'content', 'created_at', 'from_today', 'user']
            expect(res['user'].keys).to eq ['name']
            expect(response).to have_http_status(:ok)
          end
        end
      end

      context 'articles レコードのステータスが下書きのとき' do
        let(:status) { :draft }

        it 'ACtiveRecord::RecordNotFound エラーが返る' do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'article_id に対応する articles レコードが存在しないとき' do
      let(:article_id) { 10_000_000_000 }

      it 'ACtiveRecord::RecordNotFound エラーが返る' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
