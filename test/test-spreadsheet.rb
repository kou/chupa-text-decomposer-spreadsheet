class TestSpreadsheet < Test::Unit::TestCase
  include Helper

  def setup
    @decomposer = ChupaText::Decomposers::Spreadsheet.new({})
  end

  sub_test_case("decompose") do
    def decompose(fixture_name)
      path = Pathname(fixture_path(fixture_name))
      data = ChupaText::InputData.new(path)

      decomposed = []
      @decomposer.decompose(data) do |decomposed_data|
        decomposed << decomposed_data
      end
      decomposed.collect(&:body)
    end

    def test_ods
      assert_equal([<<-SHEET1, <<-SHEET2, <<-SHEET3],
"Sheet1 - A1","Sheet1 - B1"
"Sheet1 - A2","Sheet1 - B2"
      SHEET1
"Sheet2 - A1","Sheet2 - B1"
"Sheet2 - A2","Sheet2 - B2"
      SHEET2
"Sheet3 - A1","Sheet3 - B1"
"Sheet3 - A2","Sheet3 - B2"
      SHEET3
                   decompose("ods/multi-sheets.ods"))
    end

    def test_xls
      assert_equal([<<-SHEET1, <<-SHEET2, <<-SHEET3],
"Sheet1 - A1","Sheet1 - B1"
"Sheet1 - A2","Sheet1 - B2"
      SHEET1
"Sheet2 - A1","Sheet2 - B1"
"Sheet2 - A2","Sheet2 - B2"
      SHEET2
"Sheet3 - A1","Sheet3 - B1"
"Sheet3 - A2","Sheet3 - B2"
      SHEET3
                   decompose("xls/multi-sheets.xls"))
    end

    def test_xlsx
      assert_equal([<<-SHEET1, <<-SHEET2, <<-SHEET3],
"Sheet1 - A1","Sheet1 - B1"
"Sheet1 - A2","Sheet1 - B2"
      SHEET1
"Sheet2 - A1","Sheet2 - B1"
"Sheet2 - A2","Sheet2 - B2"
      SHEET2
"Sheet3 - A1","Sheet3 - B1"
"Sheet3 - A2","Sheet3 - B2"
      SHEET3
                   decompose("xlsx/multi-sheets.xlsx"))
    end
  end
end
