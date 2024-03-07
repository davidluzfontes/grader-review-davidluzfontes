CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'
RUNPATH='.:lib/junit-4.13.2.jar:lib/hamcrest-core-1.3.jar org.junit.runner.JUnitCore'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

if [ -f "student-submission/ListExamples.java" ]; then
    echo "File found"
else
    echo "File not found"
    exit 1
fi

cp student-submission/ListExamples.java grading-area/
cp TestListExamples.java grading-area/
cp -r lib grading-area

cd grading-area
javac -cp $CPATH *.java 

if [ $? -ne 0 ]; then
    echo "Compilation error!"
    GRADE=0
    echo "Grade:" $GRADE
    exit 1
fi

echo "Program compiled successfully"

java -cp $RUNPATH TestListExamples | tail -n 2 | head -n 1 > test-result.txt 


if [ $( cut -d' ' -f 1 test-result.txt ) == "OK" ]; then
    GRADE=100
    echo "Grade:" $GRADE
    exit 0
fi
echo Errors
ERRORS=$( cut -d' ' -f 6 test-result.txt )
echo Total
TOTAL=$( cut -d' ' -f 3 test-result.txt | cut -d',' -f 1 )

SUCESSES=$((TOTAL - ERRORS))
echo "Your score is $SUCESSES / $TOTAL"
# echo $FAILS
# exit 0
# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
