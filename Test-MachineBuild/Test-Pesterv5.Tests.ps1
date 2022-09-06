Param(
    [Parameter()]
    $ConfigFile = '.\MachineBuild-Config.psd1'
)

#Variables from Discovery are not available in Run 
#Unless you explicitly attach them to a Describe, Context or It using Foreach or TestCases
#If you define/capture data in descovery phase, you need to attach it with Foreach or TestCases to be able to use it in Run Phase

#Discovery phase only executes BeforeDiscovery, Describe, Context and anything else outside the It blocks
#Run phase will execute the It blocks. (BeforeAll, BeforeEach, AfterAll and AfterEach; These are just surroundings for It block, so it will execute during the Run phase)

#The glue between the two phases; -Foreach and -TestCases
#Since they are kind of isolated, you will need something to carry over. Foreach is simple, you could just use $_ ($PSItem) to loop through the whole collections.
#However 'TestCases' uses the hashtable and Pester v5 creates the variable for each Key in the hash to be accessible during the Run phase.

BeforeDiscovery {
    Write-Host "1 BeforeDicovery Outside Describe block"   
}
BeforeAll{
    Write-Host "2 BeforeAll Outside Describe block"
}

Write-Host "3 Not in any blocks Outside Describe block"

Describe "Pester v5"{
    BeforeDiscovery {
        Write-Host "4 BeforeDicovery Inside Describe block"
    }
    BeforeAll{
        Write-Host "5 BeforeAll Inside Describe block"
    }
	BeforeEach{
        Write-Host "6 BeforeEach Inside Describe block"
    }
    Write-Host "7 Not in any blocks Inside Describe block"
    It "Should be true"{
        Write-Host "8 It block Within It"
        (1 + 1) | Should -Be 2
    }
	AfterAll{
		Write-Host "9 AfterAll Inside Describe block"
	}
	AfterEach{
		Write-Host "10 AfterEach Inside Describe block"
	}
}
