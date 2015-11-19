Hi there.

I’m Thibaut, an entrepreneur and consultant from France.

Today I’d like to show you how to process data using a little ruby gem I wrote this year, called Kiba ETL.

ETL stands for Extract, Transform and Load, and it’s a common tern that you can see when you search for data processing patterns and resources.

But before processing any data, you may ask, why?

It can be quite a bit of effort to collect data and write data processing jobs, so “why would you do it in the first place?” is a very important question to ask, really.

One answer is that maybe you are building a product which unlocks the data contained in legacy systems of all kinds, where the legacy aspect makes it hard to ask specific questions. In this case, extracting the data using an ETL process, refining the data, so that you can find answers to specific questions, can provide a lot of business value.

I’m currently advising a number of SaaS startups who process data, following exactly that pattern.

It’s a very common situation these days, which provides interesting business opportunities.

Another reason to process data is what is called “integration marketing”. Imagine there is a very well established SaaS app, with a very large customer base. Implementing some level of data integration allows you to augment this app and in turn, attract their customers by providing extra value.

Again, this is a very commonly seen pattern these days, which provides a lot of value.

Of course, there is a lot more you can do with ETL and data processing in general:

You can migrate your data from a schema to another.
You can generate reports automatically
Synchronize all or part of 2 of your apps.
Preparing data before indexing it for search engines.
Aggregate data from multiple sources to build a kind of search engine
Geocode data to present the records online to your users on a map.
Or implement data import or export kind of feature for your users.

So: we’ve seen that there is a lot of benefits that you can get out of data processing. Now how can you achieve that data processing without having to resort to painful, graphical user-interface based tools?

One solution is the Kiba gem that I wrote, after maintaining another gem called activewarehouse-etl for years. Kiba allows to write reliable, concise, well-tested and maintainable data processing jobs with Ruby, and that’s exactly what I’m going to show you.

Kiba follows a classical ETL structure you will commonly see. A source will read rows and pass them to each transform, and once we are done, the rows will be sent to a destination.

Kiba lets you define this pipeline, this ETL pipeline in Ruby, and we’re going to see how.

Here is a first, short example of ETL pipeline described with the Kiba domain specific language or DSL. So, you will see that this is fairly classical ruby, where you can require components from outside, declare a source, here a CSV source which will use a filename, transform the data to parse some dates, use a block form to transform a row, and send the result after processing to a destination to insert it into your database.

I’m going to break down the various components later, so, hold on.

Once you have this script written, you can run it using the Kiba command line too, and it will just analyze your definition of ETL job, create the sources and the transforms, and make the data flow through the pipeline to process the data.

To implement your source, you simply create a Ruby class, which responds to “each”, and that will be responsible to yield the rows one by one. So this is really regular Ruby, with simply a constructor and one method.

Later, in your ETL declaration, you will just pass the class and the constructor parameters to Kiba, so Kiba knows how to create and instantiate the source, so that it can do its job.

Here is a quick example of a CSV-reading source. It will open a file, using the headers to build a Hash, Hashes of data, then close the file at the end. If you put this source as your Kiba source, it will just yield one row per CSV line.

Of course, you can have much more complex sources. This one for instance will fetch a number of invoices using Recurly (Recurly is a subscription and billing system that I often use when implementing SaaS apps), using their Ruby API, and we will cache the result locally so that you can iterate faster when implementing and improving your ETL job, which is a nice feature to have when you’re developing it.

As previously, from there, once you have your class, you can declare the source in your Kiba ETL script, and the arguments will be passed by Kiba to your source, and then the source will yield one row after another so that it can feed the ETL pipeline.

In a very similar fashion, a Kiba transform is just a Ruby class which responds to “process”. It will receive the row at one stage of the pipeline; you can modify it as you want, and then you have to return it so that it can be passed to the next step of the pipeline, using the exact same type of syntax. You use the “transform” keyword in your DSL to declare that the pipeline must apply your transform at this specific stage.

Here is a concrete example, a very simple one, using keywords arguments in Ruby by the way, to create a reusable component, a transform component, which will parse your data, probably a string, and try to transform it into a Date Ruby instance using the specific format that you are passing. This comes handy as a very reusable component to do data parsing.

Finally, a destination, which is the end of the pipeline. The destination, likewise, is still a Ruby class with a number of methods. It must repond to “write”, and will take on responsability to send the row to the target datastore. The “close” method must also be implemented to finalize any resource, like closing a file or a database connection.

Here is again a simple example of a CSV destination. It’s a common pattern in ETL to write down flat files at the end of your processing, so that you can bulk load using database-specific tools to load the data in the database at a faster pace, and here we will just create a file, write the headers using the keys of the first row provided by the pipeline, and then close the file at the end to close it properly.

So, in short, Kiba ETL provides a code-centric ETL, which means that you can work properly and version your ETL jobs in git using branches and all the features you are used to when dealing with your Ruby code usually. You can have tested components. As you saw, there is a clear separation of concerns, which means that you can have very specific components, and that they are quite easy to put under tests, unlike a typical ETL process or component. Obviously this makes those components very reusable, like the CSV components that we saw, the date manipulation, you can reuse a lot of this stuff across all your jobs and across your teams, as well.

This makes these ETL jobs very easy to maintain on the very long run. Actually I wrote a job with a similar syntax using activewarehouse-etl in like, 2006, and they’re still in production, unaffected, and people with less experience have been able to update it and modify it without issue. It’s very easy to manipulate them, they provide a low technical debt solution.

Another advantage is that you can tap easily in the Ruby ecosystem and use existing gems for all kinds of features: it can be bank account number format validation, databases of all kinds, http requests, redis caching, geocoding, etc. There is a lot of features that you can reuse in your ETL, which is pretty nice to have.

And finally I’ll soon provide blueprints and specific components like a multithreaded version in what I call “Kiba Pro”, which is a pro offering.

If you’re building or scaling something where data is important and you want me to help, please get in touch, so that we can discuss a collaboration.

Let’s prepare a very simple example of data processing, super basic, so you can get the basics, exactly. It’s a Ruby project so we’re going to create a Gemfile first, with a number of gems with use: kiba, themoviedb, because we’re going to enrich a CSV file containing movies names, movies titles, with data coming from the moviedb API.

So you create your Gemfile and yeah, we’re going to use the awesome-print gem, which is very nice to color-print data structures, so you can save your eyes from pain.

I’m just going to run bundle install so we have all the required gems, and then in movies.etl, our script, which we can color like Ruby, we’re going to declare the classes that we need to build the source. Like that… We’re going to use keywords arguments… And then from now it will do just nothing.

Then we can declare our CSV job, like that, and we can run it, like that. It does nothing for the moment. I’m going to change that and modify the source, so it can do something meaningful.

I’m going to improve it and implement the “each” method, relying on the CSV library of Ruby itself. We open the file, we iterate over each of the rows, and then we yield one row per line of CSV, and at the end we will close the CSV file.

What happens at this stage? It works, but we don’t see anything, and it would be nice to be able to have a look at what is happening exactly.

Here is how we can do that: just after the source declaration, declare a little transform as a block form, and we will just “puts” the row, like that. And then we pass it, we return it as a result, so that it’s not lost in the pipeline of processing.

We run again, and then we have our data.

But it’s a bit hard on the eyes, so we can use awesome-print, like that. This way, we launch again and we will have a color output, which is much easier on the eyes. Now, we have this file here, and, it’s not really clean, we are mixing the implementation with the declaration of the source ETL process, so what we can do is just copy this part into a separate “common.rb” file that we can reuse. Let’s do that.
Like that. And then we just require the correct file and start again. It works. Great!

Now it’s not exactly super useful, because we don’t do anything at all from the data.

So, you can sign-up at the moviedb website to get an API key. We are going to store the API key in a little file “.themoviedb” and then read the key like that.

If you run it, it still works. Then, we would like to enrich the data that we have, to add the ratings and the votes counts provided by the Movie database, to our pipeline of data.

We can also use Ruby to create small DSL extensions. For instance, let’s do that for the awesome-print transform. What if we could only call “show_me!” like that, and it would show the lines?

If we do it like that, it will fail, but we can implement that leveraging Ruby. This way you can create sweet extensions of the DSL, to be more productive. It works.

Similarly, it’s often a good idea to work on a very small subset of your data, so you can have a clear idea of what is happening, before working on a larger scale. What if you could write “limit” to just keep one row? We can do exactly that, this way. Like that.

We can also leverage things like environment variables. It still works, and we can limit if needed, like that. So again, being able to zoom and to show the data and to limit the processing to a subset is very useful when you iteratively develop a feature of an ETL job.

But now, we need to query the movie database, to enrich the data that we have in our dataset. Let’s do that! So, how can we achieve the moviedb look-up?

We’re going to create a little class, pass it the moviedb API key, and decide on which field the lookup should occur. Then later in the process, process will be called by the Kiba pipeline, and we will achieve a simple lookup of the movie, using the title field, and for the moment, to keep things simple, we’ll just pick the first one. And then we are going to store in our row the votes average and the votes count, so we can have a better data.

Let’s save that. And then, we need to put it here: “transform” the movie, how is it called already, TheMovieDB lookup, yeah. Api key. And then title field which is just “title”.

So now we have a source, with a limit, a configurable limit, and we show the limit right after the source, we transform it through the moviedb lookup, and then we show it again. Let’s run that.

You see the data before the transform, and after. You see, before, we don’t have vote average, and after the transform, we have a vote average. So, let’s comment this out, and now run that without a limit.

Here we are! We have our improved data. And now maybe we want to dump that into some data destination, like that. So here we just open a file initially. For the first row, we are going to use the keys of the row, and then later pour the values and close the file at the end. Let’s do that again, with a little limit to go faster for now. Commenting out the “show_me!”.

Woops! Woops again! This time it works, but you don’t show anything. What if we could print the output straight from the ETL job? You can do that with another feature of Kiba called the “post_process”, which is simply a block that will be called at the end of the processing. We can do things like this one. Oh, the post_process is not executing, because the limit we implemented just aborts everything. So maybe you can just modify the limit so that it will not stop the program, but return an empty row instead, like that. Save that again.

This time, our process is ran. It’s not super clear, so we can improve it a bit, using a tool like csvfix. It will pretty print our CSV file, which is a bit easier on the eyes again.

If we do that without the limit at all, wait a bit, here is our data!

Maybe now we want to only keep the very good movies, with at least a vote of 8. Let’s do that, it’s quite easy. You can do that this way. Make sure to place this transform after the moviedb lookup, like that. We’re going to remove the row from the pipeline unless a certain condition is respected.

That’s it! So in short, we have a fairly easy-to-maintain, reusable components that have very specific concerns, which are able to enrich our movies.csv into a better movies.csv with proper filtering, and better data. That’s it!

If your project involves ETL, with or without Kiba ETL, and you want me to help, please get in touch so we can discuss it.
