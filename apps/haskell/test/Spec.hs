import Test.Hspec
import qualified BasicAlgorithmsSpec
import qualified ArraysSpec
import qualified SearchAlgorithmsSpec
import qualified StacksAndQueuesSpec
import qualified RecursionSpec
import qualified SortAlgorithmsSpec
import qualified StringsSpec
import qualified LinkedListsSpec
import qualified TreesSpec

main :: IO ()
main = hspec $ do
  BasicAlgorithmsSpec.spec
  ArraysSpec.spec
  SearchAlgorithmsSpec.spec
  StacksAndQueuesSpec.spec
  RecursionSpec.spec
  SortAlgorithmsSpec.spec
  StringsSpec.spec
  LinkedListsSpec.spec
  TreesSpec.spec
