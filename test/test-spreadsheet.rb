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
Sheet1 - A1\tSheet1 - B1
Sheet1 - A2\tSheet1 - B2
      SHEET1
Sheet2 - A1\tSheet2 - B1
Sheet2 - A2\tSheet2 - B2
      SHEET2
Sheet3 - A1\tSheet3 - B1
Sheet3 - A2\tSheet3 - B2
      SHEET3
                   decompose("ods/multi-sheets.ods"))
    end

    def test_xls
      assert_equal([<<-SHEET1, <<-SHEET2, <<-SHEET3],
Sheet1 - A1\tSheet1 - B1
Sheet1 - A2\tSheet1 - B2
      SHEET1
Sheet2 - A1\tSheet2 - B1
Sheet2 - A2\tSheet2 - B2
      SHEET2
Sheet3 - A1\tSheet3 - B1
Sheet3 - A2\tSheet3 - B2
      SHEET3
                   decompose("xls/multi-sheets.xls"))
    end

    def test_xls_broken
      log = capture_log do
        assert_equal([], decompose("xls/broken.xls"))
      end
      assert_equal([
                     [
                       :error,
                       "[decomposer][spreadsheet] Invalid format: " +
                       "Ole::Storage::FormatError: OLE2 signature is invalid"
                     ],
                   ],
                   log)
    end

    def test_xlsx
      assert_equal([<<-SHEET1, <<-SHEET2, <<-SHEET3],
Sheet1 - A1\tSheet1 - B1
Sheet1 - A2\tSheet1 - B2
      SHEET1
Sheet2 - A1\tSheet2 - B1
Sheet2 - A2\tSheet2 - B2
      SHEET2
Sheet3 - A1\tSheet3 - B1
Sheet3 - A2\tSheet3 - B2
      SHEET3
                   decompose("xlsx/multi-sheets.xlsx"))
    end
  end
end
