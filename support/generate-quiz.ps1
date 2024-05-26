param (
$in = "quizzes.csv",
$out = "quizzes.js"
)

$csvFilePath = $in

# Path to the output JavaScript file
$outputFilePath = $out

# Read the CSV file
$csvData = Import-Csv -Path $csvFilePath

# Initialize the content for the quizzes.js file
$quizzesJsContent = "const quizzes = ["

# Loop through each row in the CSV file
foreach ($row in $csvData) {
    $question = $row.question
    $type = $row.type
    $choices = @()
    $correct = @()
    $explanation = $row.explanation

    # Check each choice and add the non-blank ones to the choices array
    for ($i = 1; $i -le 5; $i++) {
        $choice = $row."choice$i"
        if (-not [string]::IsNullOrWhiteSpace($choice)) {
            $choices += $choice
            if ($row."c$i" -eq "true") {
                $correct += ($choices.Count - 1)
            }
        }
    }

    # Format the question, choices, correct answers, and explanation into a JavaScript object
    $quizObject = @{
        question = $question
        type = $type
        choices = $choices
        correct = $correct
        explanation = $explanation
    }

    # Convert the PowerShell object to a JSON string without extra escaping
    $quizJson = ($quizObject | ConvertTo-Json -Compress) -replace '\\\\', '\\' -replace '\\\"', '\"'

    # Add the JSON string to the quizzes array in the quizzes.js file
    $quizzesJsContent += "$quizJson,"
}

# Remove the trailing comma and close the quizzes array
$quizzesJsContent = $quizzesJsContent.TrimEnd(',') + "];"

# Write the content to the quizzes.js file
Set-Content -Path $outputFilePath -Value $quizzesJsContent

Write-Output "quizzes.js file has been generated successfully."
