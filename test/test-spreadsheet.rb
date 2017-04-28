class TestSpreadsheet < Test::Unit::TestCase
  include Helper

  def setup
    @decomposer = ChupaText::Decomposers::Spreadsheet.new({})
  end

  sub_test_case("decompose") do
    def decompose(input_body)
      data = ChupaText::Data.new
      data.mime_type = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      data.body = input_body

      decomposed = []
      @decomposer.decompose(data) do |decomposed_data|
        decomposed << decomposed_data
      end
      decomposed
    end

    def test_body
      input_body = "TODO (input)"
      expected_text = "TODO (extracted)"
      assert_equal([expected_text],
                   decompose(input_body).collect(&:body))
    end
  end
end
