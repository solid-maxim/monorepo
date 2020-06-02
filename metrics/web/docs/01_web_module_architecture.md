# Metrics Web module architecture
> Summary of the proposed change.

# References
> Link to supporting documentation, GitHub tickets, etc.

# Motivation
> What problem is this project solving?

# Goals
> Identify success metrics and measurable goals.

# Non-Goals
> Identify what's not in scope.

# Design
> Explain and diagram the technical design.

## Clean architecture fundamentals
> Explain the basic principles of the [Screaming architecture](https://blog.cleancoder.com/uncle-bob/2011/09/30/Screaming-Architecture.html).

> Explain what are the application layers and why do we need them.

> Explain the clean architecture dependency rule.

## Metrics Web Application modules
> Explain the components of the application module.

> List all current modules.

## Clean architecture in the Metrics Web Application
> Explain the way we are implementing the clean architecture in the Metrics Web Application.

> Add the abstract class diagram with packages that will explain the main class and layers relationships.

## Metrics Web Application data layer
> Explain what a `data` layer is and what it consists of in terms of the Metrics Web Application.

> Explain what a `model` is.

> Explain what a `repository` is.

## Metrics Web Application domain layer
> Explain what a `domain` layer is and what it consists of in terms of the Metrics Web Application.

> Explain what an `entity` is.

> Explain what a `Use Case` is.

> Explain why a `domain` contains a `repository` as well.

## Metrics Web Application presentation layer
> Explain what a `presentation` layer is and what it consists of in terms of the Metrics Web Application

> Explain what a `model (view model)` is.

> Explain what a `page/widget` is.

> Explain what a `state` is.

## Communication between layers
> Explain and diagram how do these three layers work together more detailed.

> Explain how the `presentation` layer works with the `domain` layer and how the `domain` layer works with the `data` layer.

1. Add a data flow diagram explaining data migrations and transformations in the context of layers.
    `data layer(repo)` -> `domain(use case)` -> `presentation(store)` -> `view(UI)` and vice-versa

# Package structure
> Explain and diagram the Metrics Web Application package structure.

# Dependencies
> What is the project blocked on?

No blockers.

> What will be impacted by the project?

# Alternatives Considered
> Summarize alternative designs (pros & cons).

# Results
> What was the outcome of the project?