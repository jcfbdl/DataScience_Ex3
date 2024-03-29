##########################################################################
# HEC Lausanne - MScF
# Data Science for Finance
# Exercise Session 3 - 14.10.2019
# Marceau Pierron, Taulant Ukshini, David Sasselli, Nora Koennyu
##########################################################################

X=read.delim("datalausanneequity.csv",sep=";",header=FALSE)
X=diff(as.matrix(log(X)),1)

#Markowitz
mu=apply(X,2,mean)
sigma=cov(X)
sigmainv=solve(sigma)
gamma=3
w=1/gamma*sigmainv%*%mu
#rP=X%*%w
#P=cumprod(1+rP)
#plot(P)


#subsampling
wshrink=0.2
wtotal=c()             #creates a vector to stock the weights
wsigma=c()
wmu=c()
count=0                 #counter defined and set to 0
for (i in 1:1000)        #starts a 500 rounds boucle
{
  u=round(runif(1,500,nrow(X)),0)               
  #generates a random number/date from the dataset matrix X
  sample=X[(u-499):(u),]                        
  #creates a vector sample of 500 dates with respect to u
  check=try(solve(var(sample)),silent=TRUE)     
  #tests if it can calculate the variance of the sample
  if (is.character(check))                      
    #if it reaches a result (check=1)
  {
    count=count+1                             
    #it continues the boucle augmenting the counter
  } else                                      #otherwise
  { 
    mutemp=apply(sample,2,mean)               
    #calculates the mean of the subsample
    sigmainvtemp=solve(cov(sample))           
    #calculates sigma inverse of the subsample
    
    #model the constant correlation matrix
    F_Mat=matrix(,nrow=452,ncol=452)
    Corr_Av=mean(cor(sample))
    print(Corr_Av)
    StDev=apply(sample,2,sd)
    for(i in 1:452){
      for(j in 1:452){
        if(i==j){
          F_Mat[i,j]=StDev[i]*StDev[j]
        }
        
        else{
          F_Mat[i,j]=Corr_Av*StDev[i]*StDev[j]
        }
      }}                                
      
      
    Sigmashrinktemp=F_Mat*wshrink+((1-wshrink)*diag(452))%*%sigmainvtemp
    Sigmashrinkinvtemp=solve(Sigmashrinktemp)
    
    temp=1/gamma*Sigmashrinkinvtemp%*%mu            
    #computes markowitz weights using the sigma of
    #the subsample and the population mean
    wsigma=rbind(wsigma,t(temp))              
    #the new sigma is the same sigma plus the vector temp
    temp=1/gamma*Sigmashrinkinvtemp%*%mutemp        
    #computes markowitz using subsample mean and sigma
    wtotal=rbind(wtotal,t(temp))             
    #total weight is the 
    temp=1/gamma*sigmainv%*%mutemp            
    #computes markowitz using the population sigma and the subsample mean
    wmu=rbind(wmu,t(temp))                    
    #the new mu is the same wmu plus the vector temp 
  }
  print(c(i,count/500))
}
layout(matrix(1:2,1,2))

#boxplot(wsigma[,1:20],ylim=c(-10,10))
#boxplot(wmu[,1:20],ylim=c(-10,10))
boxplot(wtotal[,1:20],ylim=c(-400,400), main="regularized")


#Recreates first boxplot
X=read.delim("datalausanneequity.csv",sep=";",header=FALSE)
X=diff(as.matrix(log(X)),1)

#Markowitz
mu=apply(X,2,mean)
sigma=cov(X)
sigmainv=solve(sigma)
gamma=3
w=1/gamma*sigmainv%*%mu
#rP=X%*%w
#P=cumprod(1+rP)
#plot(P)

#subsampling
wtotal=c()             #creates a vector to stock the weights
wsigma=c()
wmu=c()
count=0                 #counter defined and set to 0
for (i in 1:1000)        #starts a 500 rounds boucle
{
  u=round(runif(1,500,nrow(X)),0)               
  #generates a random number/date from the dataset matrix X
  sample=X[(u-499):(u),]                        
  #creates a vector sample of 500 dates with respect to u
  check=try(solve(var(sample)),silent=TRUE)     
  #tests if it can calculate the variance of the sample
  if (is.character(check))                      
    #if it reaches a result (check=1)
  {
    count=count+1                             
    #it continues the boucle augmenting the counter
  } else                                      #otherwise
  { mutemp=apply(sample,2,mean)               
   #calculates the mean of the subsample
  sigmainvtemp=solve(cov(sample))           
   #calculates sigma inverse of the subsample
  temp=1/gamma*sigmainvtemp%*%mu            
   #computes markowitz weights using the sigma of the
   #subsample and the population mean
  wsigma=rbind(wsigma,t(temp))              
   #the new sigma is the same sigma plus the vector temp
  temp=1/gamma*sigmainvtemp%*%mutemp        
   #computes markowitz using subsample mean and sigma
  wtotal=rbind(wtotal,t(temp))              
   #total weight is the 
  temp=1/gamma*sigmainv%*%mutemp            
   #computes markowitz using the population sigma and the subsample mean
  wmu=rbind(wmu,t(temp))                    
   #the new mu is the same wmu plus the vector temp 
  }
  print(c(i,count/500))
}
#layout(matrix(1:3,1,3))

boxplot(wtotal[,1:20],ylim=c(-400,400), main="mu and sigma updated")
#boxplot(wmu[,1:20],ylim=c(-400,400), main="mu updated")
#boxplot(wsigma[,1:20],ylim=c(-400,400), main="sigma updated")

