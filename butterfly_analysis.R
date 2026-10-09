# Borneo butterfly population analysis
# Based on the original R code in the appendix of my university report.
# The only functional change is to read the two provided CSV files instead
# of referencing datasets that were previously loaded into RStudio.
# Run from the folder containing butterfly_counts.csv and butterfly_dynamics.csv.

butterfly_counts <- read.csv("butterfly_counts.csv", check.names = TRUE)
butterfly_dynamics <- read.csv("butterfly_dynamics.csv", check.names = TRUE)

#str
str(butterfly_counts)
str(butterfly_dynamics)

# abundance differs between sites hyp1
# single response vector of counts
Abundance <- c(butterfly_counts$Sabah,
               butterfly_counts$Sarawak,
               butterfly_counts$West.Kalimantan,
               butterfly_counts$East.Kalimantan)

#match site factor
Site <- c(rep("Sabah", length(butterfly_counts$Sabah)),
          rep("Sarawak", length(butterfly_counts$Sarawak)),
          rep("West.Kalimantan", length(butterfly_counts$West.Kalimantan)),
          rep("East.Kalimantan", length(butterfly_counts$East.Kalimantan)))
Site <- factor(Site)

# plot da ting
plot(Abundance ~ Site)

#GLM for count data
m_abund <- glm(formula = Abundance ~ Site,
               family = poisson(link = "log"))
summary(m_abund)

#dispersion check for gang
residual_deviance <- summary(m_abund)$deviance
residual_df <- summary(m_abund)$df.residual
dispersion_abund <- residual_deviance / residual_df
dispersion_abund

# resilience differs between sites hyp2
#Combine abundance for all da sites
Abundance_dyn <- c(butterfly_dynamics$Sabah,
                   butterfly_dynamics$Sarawak,
                   butterfly_dynamics$West.Kalimantan,
                   butterfly_dynamics$East.Kalimantan)

# wack together PGR for all sites
PGR <- c(butterfly_dynamics$PGR.Sabah,
         butterfly_dynamics$PGR.Sarawak,
         butterfly_dynamics$PGR.W.Kalimantan,
         butterfly_dynamics$PGR.E.Kalimantan)

#big man gotta match the site factors
Site_dyn <- c(rep("Sabah", length(butterfly_dynamics$Sabah)),
              rep("Sarawak", length(butterfly_dynamics$Sarawak)),
              rep("West.Kalimantan", length(butterfly_dynamics$West.Kalimantan)),
              rep("East.Kalimantan", length(butterfly_dynamics$East.Kalimantan)))
Site_dyn <- factor(Site_dyn)

#plot to see density dependance
plot(Abundance_dyn, PGR,
     xlab = "Abundance (count per hour)",
     ylab = "Population growth rate (PGR)")

#run the linear model to see if the PGR–abundance relationship differ between sites
m_resilience <- lm(PGR ~ Abundance_dyn * Site_dyn)
summary(m_resilience)

#now working out the carrying capacity per site
#big ups Statistics bio7 on the yt for the help doing: separate regressions per site

#sabah
m_Sabah <- lm(PGR.Sabah ~ Sabah, data = butterfly_dynamics)
coef(m_Sabah)
K_Sabah <- -coef(m_Sabah)[1] / coef(m_Sabah)[2]
K_Sabah

#sarawak
m_Sarawak <- lm(PGR.Sarawak ~ Sarawak, data = butterfly_dynamics)
coef(m_Sarawak)
K_Sarawak <- -coef(m_Sarawak)[1] / coef(m_Sarawak)[2]
K_Sarawak

#west kalimantan
m_WK <- lm(PGR.W.Kalimantan ~ West.Kalimantan, data = butterfly_dynamics)
coef(m_WK)
K_WestKalimantan <- -coef(m_WK)[1] / coef(m_WK)[2]
K_WestKalimantan

#moving onto the Easide (city where the sun dont set) (east kalimantan)
m_EK <- lm(PGR.E.Kalimantan ~ East.Kalimantan, data = butterfly_dynamics)
coef(m_EK)
K_EastKalimantan <- -coef(m_EK)[1] / coef(m_EK)[2]
K_EastKalimantan
