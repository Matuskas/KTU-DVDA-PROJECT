library(h2o)
library(xgboost)

h2o.init(max_mem_size = "12g")

df <- h2o.importFile("../1-data/train_data.csv")
test_data <- h2o.importFile("../1-data/test_data.csv")
class(df)
summary(df)
h2o.impute(df, "max_open_credit", method = "median")
h2o.impute(df, "yearly_income", method = "mean", by = c("home_ownership"))
h2o.impute(df, "years_current_job", method = "mean")
summary(df)

y <- "y"
x <- setdiff(names(df), c(y, "id"))
df$y <- as.factor(df$y)


splits <- h2o.splitFrame(df, c(0.6,0.2), seed=123)
train  <- h2o.assign(splits[[1]], "train") # 60%
valid  <- h2o.assign(splits[[2]], "valid") # 20%
test   <- h2o.assign(splits[[3]], "test")  # 20%

aml <- h2o.automl(x = x,
                  y = y,
                  training_frame = train,
                  validation_frame = valid,
                  max_runtime_secs = 150)

aml@leaderboard

#model <- aml@leader
#model <- h2o.getModel("GBM_1_AutoML_1_20231227_110205")

#h2o.performance(model, train = TRUE)
#h2o.performance(model, valid = TRUE)
#h2o.performance(model, newdata = test_data)



# 2023.11.10

rf_model <- h2o.randomForest(x,
                             y,
                             training_frame = train,
                             validation_frame = valid,
                             ntrees = 20,
                             max_depth = 10,
                             stopping_metric = "AUC",
                             seed = 1234)
rf_model
h2o.auc(rf_model)
h2o.auc(h2o.performance(rf_model, valid = TRUE))
h2o.auc(h2o.performance(rf_model, newdata = test))


# Write GBM?


gbm_model <- h2o.gbm(x,
                     y,
                     training_frame = train,
                     validation_frame = valid,
                     ntrees = 35,
                     max_depth = 15,
                     stopping_metric = "AUC",
                     seed = 1234)
h2o.auc(gbm_model)
h2o.auc(h2o.performance(gbm_model, valid = TRUE))
h2o.auc(h2o.performance(gbm_model, newdata = test))


predictions <- h2o.predict(gbm_model, test_data)

predictions

predictions %>%
  as_tibble() %>%
  mutate(id = row_number(), y = p0) %>%
  select(id, y) %>%
  write_csv("../5-predictions/predictions3.csv")

h2o.saveModel(gbm_model, "../4-model/", filename = "gbm_model1")

h2o.varimp_plot(gbm_model)

# Grid search


dl_params <- list(ntrees = list(10,20,30,40,50,60), max_depth = list(10,20,25,30))

dl_grid <- h2o.grid(algorithm = "gbm",
                    grid_id = "ktu_grid",
                    x,
                    y,
                    training_frame = train,
                    validation_frame = valid,
                    stopping_metric = "AUC",
                    hyper_params = dl_params)


h2o.getGrid(dl_grid@grid_id, sort_by = "auc")

best_grid <- h2o.getModel(dl_grid@model_ids[[1]])




