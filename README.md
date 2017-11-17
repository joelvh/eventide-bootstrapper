
# Getting Started with Eventide

## Philosophy

* Avoid overriding methods like the plague for the most part - that, and the use of `super`
* If we end up with something that requires comments to be clear, we re-write it until it’s clear
* About maintaining multiple gems in one repository: We keep things that are separate, separate. It’s the laws of software physics that dictate the structure, rather than developer convenience, etc

## Project Structure

TODO

* Package each component into it's own gem
    * Create a "client"

### Basics

Classes and modules are setup with some helper methods to build objects. Maybe this can be compared to the DSL people become used to when defining schemas with an ORM, but really they're helpers to setup and configure accessors and object instances.

    class SomeModel
      require 'attribute'

      # Define an accessor called `email` with a default value of "unknown@unknown.com".
      # (Alternatively, you can create a `:reader` or `:writer` instead.)
      Attribute::Define.(self, :email, :accessor){ 'unknown@unknown.com' }



### Initialization

* Consumer can be "started" to run: https://github.com/eventide-project/consumer-postgres
    * Example of starting various consumers: https://github.com/eventide-examples/account-component/blob/master/lib/account_component/start.rb
    * Component Host is recommended to run Consumer in production: https://github.com/eventide-project/component-host



Tracing application loading:

* eventide-postgres:
    * entity_store
        * entity_cache
            * configure
                * ostruct
                * configure/macro
                * configure/activate
            * `Configure.activate`
                * Extends `Object` with `Configure::Macro` and `default_factory_method` is `nil` (but will then default to `:build` in getter)
                    * Adds `configure` (aliased from `configure_macro`) class and instance method
                        * TODO: Determine what this does
            * message_store
                * pp
                * json
                * casing
                * identifier/uuid
                * schema
                * initializer
                    * attribute
                        * attribute/define
                    * initializer/parameter
                    * initializer/generator
                    * initializer/visibility
                    * initializer/macro
                    * initializer/activate
                * `Initializer.activate`
                    * Extends `Object` with `Initializer::Macro`
                        * Adds `initializer` (aliased from `initializer_macro`) class and instance method
                * transform
                    * log
                    * transform/log
                    * transform/transform
                    * transform/write
                    * transform/read
                    * transform/copy
                * virtual
                    * virtual/method
                    * virtual/pure_method
                    * virtual/macro
                    * virtual/activate
                * `Virtual.activate`
                    * Extends `Object` with `Virtual::Macro`
                        * Adds `virtual` (aliased from `virtual_macro`) class method - seems to simply define a method
                        * Adds `pure_virtual` (aliased from `pure_macro`) class method
                        * Adds `abstract` (aliased from `pure_macro`) class method
                * async_invocation
                    * async_invocation/incorrect
                * _TODO: finish listing_
            * settings
                * pathname
                * json
                * log
                * casing
                * attribute
                * dependency
                    * subst_attr
                        * naught
                        * attribute
                        * subst_attr/substitute
                        * subst_attr/attribute
                        * subst_attr/macro
                        * subst_attr/activate
                    * dependency/macro
                    * dependency/activate
                * `Dependency.activate`
                    * Extends `Object` with `Dependency::Macro`
                        * Adds `dependency` (aliased from `dependency_macro`) class method - seems to define a method that returns a `SubstAttr::Substitute`, which can be a `NullObject` that swallows "undefined method" errors??
            * telemetry
            * entity_cache/log
            * entity_cache/defaults
            * entity_cache/record
            * entity_cache/record/destructure
            * entity_cache/record/log_text
            * entity_cache/record/transformer
            * entity_cache/store/internal
            * entity_cache/store/internal/build
            * entity_cache/store/internal/build/defaults
            * entity_cache/store/internal/scope/exclusive
            * entity_cache/store/internal/scope/global
            * entity_cache/store/internal/scope/thread
            * entity_cache/store/internal/substitute
            * entity_cache/entity_cache
            * entity_cache/substitute
        * entity_projection
        * entity_store/log
        * entity_store/entity_store
        * entity_store/substitute
    * consumer/postgres
    * entity_snapshot/postgres

## Setup Message Store (Postgres)

Setup the Eventide Message Store as Postres database (_see [Setup](http://docs.eventide-project.org/setup.html)_)

    # install the gem
    gem install evt-message_store-postgres

    # create the database
    evt-pg-create-db

Additional information about Postgres database settings: https://github.com/eventide-project/docs/blob/master/book/install_and_setup/postgres_database.md

### Eventide Database Commands

* `evt-pg-create-db`
* `evt-pg-delete-db`
* `evt-pg-list-events`
* `evt-pg-recreate-db`

## Quickstart

Get started with a [really simple example setup](http://docs.eventide-project.org/quickstart.html).

### Workshop Tutorial

Alternatively, there's a [workshop tutorial](https://github.com/eventide-tutorial/workshop/blob/master/setup.md) that can be followed with other examples.

# Customizing Eventide

## Environment Variables

* `eventide-postgres`
    * Scripts:
        * `POSTURE`
* `messaging-postgres`
    * Tests:
        * `LOG_TAGS`
        * `PERIOD`
* `message-store-postgres`
    * Scripts:
        * `DATABASE_USER`
        * `DATABASE_NAME`
        * `TABLE_NAME`
        * `STREAM_NAME`
    * Tests:
        * `CONSOLE_DEVICE`
        * `LOG_LEVEL`
    * `LIBRARIES_HOME`

## Server Configuration

### Database Connection

TODO: How to configure database connection using environment variables

# Reference

* [Design Values](https://eventide-project.org/design-values)
    * General Design Values
        * [Useful Objects](https://eventide-project.org/useful-objects)
            * [Doctrine of Useful Objects](https://github.com/sbellware/useful-objects/blob/master/README.md)
        * Controllable
        * _"Push, rather than pull"_
        * Behavioral objects
        * Limited data object interfaces
        * Explicit dependencies
        * Substitutes
        * Telemetry
        * Logging
        * Composition
        * Limited primitive initialization
        * Class constructors
        * Protocol discovery
        * Strict regulation of monkey-patching
        * Controls
    * Service Design Values
        * Commands and Events
        * Autonomy
        * No queries
        * Dumb pipes, smart endpoints
        * Architecture, not infrastructure
        * Projection side effects
        * Entities are data structures
        * Immutability of messages
        * Components
* Concepts & Terminology
    * [Introductory Examples](https://eventide-project.org/intro)
        * Handlers
        * Commands
        * Events
        * Entities
        * Stores
        * Projections
    * [Features](https://eventide-project.org/#features-section)
        * Message Store
        * Messaging
        * Entity Projection
        * Entity Store
        * Entity Cache
        * Entity Snapshot
        * Consumer
        * Component Host
        * _Other Features_
    * [Libraries](https://eventide-project.org/libraries)
        * Top-level libraries
            * [eventide-postgres](https://github.com/eventide-project/eventide-postgres) - Event-Oriented Autonomous Services Toolkit for _Postgres_
            * [eventide-event_store](https://github.com/eventide-project/eventide-event-store) - Event-Oriented Autonomous Services Toolkit for _Event Store_
        * Core libraries
            * [message_store](https://github.com/eventide-project/message-store) - Common primitives for platform-specific message store implementations
            * [messaging](https://github.com/eventide-project/messaging) - Common primitives for platform-specific messaging implementations for Eventide
            * [entity_projection](https://github.com/eventide-project/entity-projection) - Projects event data into an entity
            * [entity_store](https://github.com/eventide-project/entity-store) - Store of entities that are projected from streams
            * [entity_cache](https://github.com/eventide-project/entity-cache) - Cache of entities retrieved by an entity-store, with in-memory temporary and on-disk permanent storage options
            * [consumer](https://github.com/eventide-project/consumer) - Consumer library that maintains a long running subscription to an event stream
            * [component_host](https://github.com/eventide-project/component-host) - Host components inside a single physical process
            * [view_data-commands](https://github.com/eventide-project/view-data-commands) - Message schemas for data-oriented command streams used to populate view databases
        * Postgres libraries
            * [message_store-postgres](https://github.com/eventide-project/message-store-postgres) - Message store implementation for PostgreSQL
            * [messaging-postgres](https://github.com/eventide-project/messaging-postgres) - Eventide messaging for Postgres
            * [entity_snapshot-postgres](https://github.com/eventide-project/entity-snapshot-postgres) - Projected entity snapshotting for Postgres
            * [consumer-postgres](https://github.com/eventide-project/consumer-postgres) - Category and stream consumer for Postgres
            * [view_data-pg](https://github.com/eventide-project/view-data-pg) - Populate Postgres view databases from event streams
            * [command_line-component_generator](https://github.com/eventide-project/command-line-component-generator) - Command line project generator
        * Event Store libraries
        * Utility libraries
        * Third-party libraries

## Dependency Graph

    eventide-postgres (0.2.0.2)
      evt-consumer-postgres (0.2.2.0)
        evt-consumer (0.7.0.0)
          evt-configure (0.1.2.5)
          evt-cycle (0.3.0.3)
            evt-clock (0.4.0.7)
              naught (1.1.0)
              tzinfo (1.2.4)
                thread_safe (0.3.6)
            evt-initializer (0.1.0.2)
              evt-attribute (0.1.3.5)
            evt-log (0.4.3.5)
              evt-clock
              evt-dependency (0.1.0.4)
                evt-subst_attr (0.1.0.2)
                  evt-attribute
                  naught
              evt-initializer
              evt-telemetry (0.3.1.0)
                evt-clock
                evt-dependency
              terminal_colors (0.0.0)
            evt-telemetry
          evt-messaging (0.24.0.0)
            evt-message_store (0.2.2.0)
              evt-async_invocation (0.1.0.4)
              evt-casing (0.3.0.3)
              evt-identifier-uuid (0.1.1.3)
                naught
              evt-initializer
              evt-schema (0.6.1.1)
                evt-attribute
                evt-set_attributes (0.3.0.2)
                evt-validate (0.3.1.5)
                evt-virtual
              evt-transform (0.1.2.0)
                evt-log
              evt-virtual (0.1.0.2)
          ntl-actor (1.2.3)
        evt-messaging-postgres (0.7.0.3)
          evt-message_store-postgres (0.4.2.0)
            evt-log
            evt-message_store
            evt-settings
            pg (0.21.0)
          evt-messaging
      evt-entity_snapshot-postgres (0.2.2.0)
        evt-entity_store (0.5.0.0)
          evt-entity_cache (0.15.0.0)
            evt-configure
            evt-message_store
            evt-settings (0.2.0.5)
              confstruct (1.0.2)
                hashie (3.5.6)
              evt-casing
              evt-log
            evt-telemetry
          evt-entity_projection (0.3.0.3)
            evt-messaging
        evt-messaging-postgres
      evt-entity_store
    evt-component_host (0.1.0.3)
      evt-async_invocation
      evt-casing
      evt-log
      evt-virtual
      ntl-actor

## Materials

* [Succeeding with Microservices: The Microservices Workshop](http://bit.ly/msvc-fundamentals)

## Code

### Gems

* [eventide](https://gemfury.com/eventide) - *outdated/unused*
