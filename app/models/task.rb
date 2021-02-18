class Task < ApplicationRecord
  belongs_to :user

  def execute
    logger.info "\e[34m[execute]\e[0m"

    source_page = get_page(self.source_page_url)
    logger.info("source_page[:title]: #{source_page[:title]}")

    tomorrow = Date.tomorrow
    page_title = source_page[:title].gsub(/YYYY/, tomorrow.strftime('%Y')).gsub(/MM/, tomorrow.strftime('%m')).gsub(/DD/, tomorrow.strftime('%d'))
    logger.info "page_title: #{page_title}"

    target_page = create_page(self.target_parent_page_url, page_title, source_page[:body])
    logger.info "target_page: #{target_page}"
  end

  private
    def get_identifiers page_url
      url = URI.parse(page_url)
      path_list = url.path.split('/')

      {
        host: url.host,
        space: path_list[3],
        page: path_list[5]
      }
    end

    def get_page page_url
      identifiers = get_identifiers(page_url)

      request = Faraday.new "https://#{identifiers[:host]}" do |req|
        req.basic_auth(self.user.email, self.user.token)
        req.params[:expand] = "body.editor2"
      end

      response = request.get("/wiki/rest/api/content/#{identifiers[:page]}")
      page = JSON.parse(response.body, symbolize_names: true)

      {
        title: page[:title],
        body: page[:body][:editor2][:value]
      }
    end

    def create_page parent_page_url, title, body
      identifiers = get_identifiers(parent_page_url)
      request = Faraday.new "https://#{identifiers[:host]}" do |req|
        req.basic_auth(self.user.email, self.user.token)
        req.headers['Content-Type'] = 'application/json'
      end

      response = request.post("/wiki/rest/api/content") do |req|
        req.body = {
          title: title,
          type: "page",
          space: {
            key: identifiers[:space]
          },
          ancestors: [
            {
              id: identifiers[:page]
            },
          ],
          body: {
            storage: {
              value: body,
              representation: "storage"
            }
          }
        }.to_json
      end

      page = JSON.parse(response.body, symbolize_names: true)
      {
        title: page[:title],
        editorUrl: "#{page[:_links][:base]}#{page[:_links][:editui]}"
      }
    end
end
