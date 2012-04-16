require './spec/spec_helper'

describe FormulaSearch do

  describe "#prepare_sql" do
    before do
      @params = { symptoms:   'fever',
                  pulse:      'halting',
                  tongue:     'red',
                  diagnosis:  'KID yang deficiency' }
    end
    let(:result_array) { FormulaSearch.prepare_sql(@params) }
    
    it "returns an array for use by Formula.find_by_sql" do
      result_array.should be_instance_of Array
    end

    describe "the return array" do
      specify "contains 5 elements: the SQL template plus 4 variable bind strings" do
        result_array.size.should == 5
      end

      describe "the SQL template" do
        it "is a SELECT statement" do
          result_array[0].should match(/^SELECT/)
        end
        it "contains four question mark placeholders" do
          result_array[0].scan(/\?/).count.should == 4
        end
      end

      describe "the 4 bind variable strings" do
        specify "pass through unchanged simple invididual search terms" do
          result_array[1].should ==('fever')
          result_array[2].should ==('halting')
        end
        specify "pass through unchanged blank search terms" do
          @params[:pulse] = ''
          result_array[2].should ==('')
        end
        specify "separate multiple terms with the | character" do
          @params[:tongue] = "white coat"
          result_array[3].should ==('white|coat')
        end
        specify "remove non-alpha characters" do
          @params[:tongue] = "pale-red body"
          result_array[3].should ==('pale|red|body')
        end
        specify "remove extra whitespace" do
          @params[:diagnosis] = "   white \n  coat  syndrome \r\n"
          result_array[4].should ==('white|coat|syndrome')
        end

        describe "synonym processing:" do
          specify "expand known synonyms, ignoring case differences" do
            @params[:pulse] = 'Rapid'
            result_array[2].should ==('rapid|fast')
          end
          specify "expand known synonyms, ignoring partial matches" do
            @params[:pulse] = 'rap'
            result_array[2].should ==('rap')
          end
          specify "expand any number of synonyms" do
            @params[:pulse] = 'rapid, choppy'
            result_array[2].should ==('rapid|fast|choppy|rough')
          end
          specify "expand synonyms without creating duplicate terms" do
            @params[:pulse] = 'rapid, fast, choppy, rough'
            result_array[2].should ==('rapid|fast|choppy|rough')
          end
        end
      end
    end
  end
end
