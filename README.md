# Common Data Science Mistakes
Common Mistakes Data Sciencists do

## Data preparation

Ignoring Data Quality: Poor data quality can severely impact the results of any data science project. Ignoring issues such as missing values, outliers, or inaccuracies can lead to biased models and erroneous conclusions

## Data Exploring

Not Exploring the Data: Failing to thoroughly explore and understand the data before building models can lead to missed opportunities and suboptimal performance. Exploratory data analysis (EDA) helps identify patterns, relationships, and potential issues in the data.


## Feature engineering

Homoscedasticity and heteroscedasticity: refers to a condition in which the variance of the residual, or error term, in a regression model is constant. 

Feature redundancy: adding higly correlated features to the model independent variables.

Handling Multicollinearity: L2 regularization can help mitigate multicollinearity issues by shrinking correlated features towards each other. This can improve the numerical stability of the model and the interpretability of the coefficients.

Data distribution: ignoring different data distributions and skewness of the distribution. Such features can be quickly corrected by applying log transformations.


Ignoring feature importance


## Data Modeling and measuring

Overfitting: Overfitting occurs when a model learns the training data too well, capturing noise along with the underlying patterns. This leads to poor generalization to new, unseen data. Regularization techniques and cross-validation can help mitigate overfitting.

Data Leakage: Data leakage occurs when information from outside the training dataset is inadvertently used to train the model, leading to inflated performance metrics that don't generalize to new data. It's crucial to ensure that the training data accurately reflects the real-world scenario.

Using the Wrong Model: Selecting the appropriate model for the task at hand is essential. Using a complex model when a simpler one would suffice (or vice versa) can lead to inefficient use of resources or subpar performance.

Not Addressing Bias and Fairness: Models trained on biased data can perpetuate or even exacerbate existing biases. It's essential to identify and mitigate bias in both the data and the models to ensure fair and equitable outcomes.

Ignoring Model Evaluation Metrics: Choosing the right evaluation metrics is crucial for assessing model performance accurately. Focusing solely on accuracy without considering other metrics like precision, recall, or F1-score can lead to misleading conclusions, especially in imbalanced datasets.


## Data reporting and  visualisation

Poor Communication: Communicating findings effectively to stakeholders is as important as building accurate models. Failing to communicate results in a clear and understandable manner can lead to misinterpretation or lack of trust in the findings.


## Business an domain knowledge

Ignoring Business Context: Data science projects should always align with the broader business objectives. Ignoring the business context can result in models that are technically sound but not useful or actionable for decision-making.

Feature engineering without the business context.

Lack of Domain Knowledge: Data scientists need a solid understanding of the domain they are working in to interpret results correctly and ask the right questions. Without domain knowledge, it's easy to misinterpret findings or overlook important variables.



