Test Web App SSL validity
=========================

            

Since on Microsoft Azure Cloud platform testing of Web App SSL validity as a check is still not available out of the box, I came up with this simple function which is reporting the validity of the Web App certificate. Function will fetch all SSL certificates,
 make sure they're unique by sorting by  property of the certificate Thumbprint, then check which certiificate is bounded to the Web App by comparing the Thumbprint and then perform mathemathical operation by comparing the expiration date property with
 custom dates.


 


Idea is to integrate this function with your automation job.


You can fetch all of your web apps into the variable and then loop over them by passing their repositorysitename and resourcegroup property to the function.


Function can be further edited to deliver the results by the custom reporting solution.

 

        
    
TechNet gallery is retiring! This script was migrated from TechNet script center to GitHub by Microsoft Azure Automation product group. All the Script Center fields like Rating, RatingCount and DownloadCount have been carried over to Github as-is for the migrated scripts only. Note : The Script Center fields will not be applicable for the new repositories created in Github & hence those fields will not show up for new Github repositories.
