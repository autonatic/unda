library(splines)
load("data/renaults.RData")
rpm <- lm(Price ~ Kilometers + Age,
     data = renault)


# predict the price for a 1 year old Renault Espace that has driven 50000 KM

# https://www.r-bloggers.com/deploying-a-car-price-model-using-r-and-azureml/
# https://longhowlam.wordpress.com/2015/08/20/deploying-a-car-price-model-using-r-and-azureml/

undebug(RenaultScorer)
RenaultScorer(rpm,50000,365)

library(AzureML)
ws <- workspace(
  id = "aa62497c09ab40d9bdf4b7b418a1ccf0",
  auth = "TQtjeIjQnIHAhAagqZ3+83hGUrpKOK1y9Tmo2mfIo+XU7fDnLPuJDGFHKtHcYZFOMYKPWsU8yF8Yb8UdT/3Glw=="
)


RenaultScorer <- function(newdata)
{
  out <- predict.lm(rpm,newdata)
  out  
}


data.frame("Kilometers" = k,
           "Age" = a)

rws <- publishWebService(ws,
  RenaultScorer,"pricing lemons",
  renault[,c("Price","Kilometers","Age")],
  data.frame = T
)

RenaultPrice <- consume(rws,
                        data.frame("Price" = 0,
                          "Kilometers" = 50000,
                             "Age" = 365,
                             stringsAsFactors = F))



# AzureML Basic example.
library(lme4)
set.seed(1)
train <- sleepstudy[sample(nrow(sleepstudy), 120),]
m <- lm(Reaction ~ Days + Subject, data = train)
predict(m,sleepstudy[1,])
# Deine a prediction function to publish based on the model:
sleepyPredict <- function(newdata){
  predict(m, newdata=newdata)
}

ep <- publishWebService(ws,
                        sleepyPredict,
                        name="sleepy lm",
                        inputSchema = sleepstudy,
                        data.frame = TRUE)

# OK, try this out, and compare with raw data
ans <- consume(ep, sleepstudy)$ans
plot(ans, sleepstudy$Reaction)

# Remove the service
deleteWebService(ws, "sleepy lm")


# more on azure: 
# http://www.nealanalytics.com/deploying-r-modelsfunctions-with-the-azureml-r-package/




