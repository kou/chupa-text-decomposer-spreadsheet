require "roo"
require "roo-xls"
require "digest/sha1"

module ChupaText
  module Decomposers
    class Spreadsheet < Decomposer
      include Loggable

      registry.register("spreadsheet", self)

      TARGET_EXTENSIONS = ["ods", "xls", "xlsx", "xlsm", "xml"]

      TARGET_MIME_TYPES = [
        "application/vnd.oasis.opendocument.spreadsheet",
        "application/vnd.ms-excel",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      ]

      def target?(data)
        TARGET_EXTENSIONS.include?(data.extension) or
          TARGET_MIME_TYPES.include?(data.mime_type)
      end

      def target_score(data)
        if target?(data)
          10
        else
          nil
        end
      end

      def decompose(data)
        open_book(data) do |book|
          book.sheets.each do |sheet_name|
            sheet = book.sheet(sheet_name)
            body = build_body(sheet)
            text_data = TextData.new(body, source_data: data)
            text_data["name"] = sheet_name
            text_data["digest"] = Digest::SHA1.hexdigest(body)
            text_data["size"] = body.bytesize
            text_data["first-row"] = sheet.first_row
            text_data["last-row"] = sheet.last_row
            text_data["first-column"] = sheet.first_column && sheet.first_column_as_letter
            text_data["last-column"] = sheet.last_column && sheet.last_column_as_letter
            yield text_data
          end
        end
      end

      private
      def open_book(data)
        book = nil
        begin
          book = Roo::Spreadsheet.open(data.path.to_s)
        rescue Ole::Storage::FormatError => format_error
          error do
            message = "#{log_tag} Invalid format: "
            message << "#{format_error.class}: #{format_error.message}\n"
            message << format_error.backtrace.join("\n")
            message
          end
          return
        end

        begin
          yield(book)
        ensure
          book.close
        end
      end

      def build_body(sheet)
        body = ""
        first_row = sheet.first_row
        return body if first_row.nil?

        1.upto(sheet.last_row) do |row|
          1.upto(sheet.last_column) do |column|
            body << "\t" if column > 1
            body << build_cell(sheet, row, column)
          end
          body << "\n"
        end

        body
      end

      def build_cell(sheet, row, column)
        return "" if sheet.empty?(row, column)

        cell = sheet.cell(row, column)
        case sheet.celltype(row, column)
        when :string
          cell
        when :time
          sheet.integer_to_timestring(cell)
        when :link
          cell.url
        else
          cell.to_s
        end
      end

      def log_tag
        "[decomposer][spreadsheet]"
      end
    end
  end
end
