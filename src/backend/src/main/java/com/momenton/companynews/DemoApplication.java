package com.momenton.companynews;

import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;
import java.util.stream.Collectors;

import com.momenton.companynews.entity.News;
import com.momenton.companynews.entity.Root;
import com.momenton.companynews.operator.DeleteNewsTransaction;
import com.momenton.companynews.operator.GetNews;
import com.momenton.companynews.operator.CreateNewsTransaction;
import com.momenton.companynews.operator.UpdateNewsTitleTransaction;

import org.prevayler.Query;

import org.prevayler.Prevayler;
import org.prevayler.PrevaylerFactory;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.CrossOrigin;

import java.util.Collection;
import java.util.Date;
import java.util.Map;

@RestController
public class DemoApplication {

	@CrossOrigin
	@RequestMapping("/")
	public String index() {
		return "Greetings from Spring Boot!";
	}

	@CrossOrigin
	@RequestMapping("/create")
	public String write(@RequestBody News inputNews) throws Exception {
		Prevayler<Root> prevayler = initPrevayler();
		try {

			String title = inputNews.getTitle();
			System.out.println(title);
			final News news = prevayler.execute(new CreateNewsTransaction(UUID.randomUUID().toString()));

			prevayler.execute(new UpdateNewsTitleTransaction(news.getID(), title));
			System.out.println("news.getTitle(): " + news.getTitle());

		} finally {
			prevayler.close();

		}
		return "create a news!";
	}

	@CrossOrigin
	@RequestMapping("/select/{id}")
	public News select(@PathVariable("id") String id) throws Exception {
		Prevayler<Root> prevayler = initPrevayler();
		System.out.println(id);
		News queryResponse;
		try {

			queryResponse = prevayler.execute(new GetNews(id));

		} finally {
			prevayler.close();

		}
		if (queryResponse != null) {
			return queryResponse;
		}

		System.out.println("cannot find news!");
		return null;
	}

	@CrossOrigin
	@RequestMapping("/select")
	public Collection<News> select() throws Exception {
		Prevayler<Root> prevayler = initPrevayler();
		Map<String, News> allNews;
		try {

			allNews= prevayler.execute(new Query<Root, Map<String, News>>() {
				private static final long serialVersionUID = -449826861014013447L;
		
				public Map<String, News> query(Root prevalentSystem, Date executionTime) throws Exception {
				  return prevalentSystem.getAllNews();
				}
			  });

		} finally {
			prevayler.close();

		}

		if (allNews != null) {
			return allNews.values();
		}

		System.out.println(allNews.keySet().stream()
		.map(key -> "id: " + key + ", title: " + ((News)allNews.get(key)).getTitle())
		.collect(Collectors.joining("</p><p>","<p>","</p>")));

		return null;
	}

	@CrossOrigin
	@RequestMapping("/count")
	public String count() throws Exception {
		Prevayler<Root> prevayler = initPrevayler();
		int count = -1;
		try {
			count = prevayler.execute(new Query<Root, Integer>() {
				private static final long serialVersionUID = -4739548462309688139L;
		
				public Integer query(Root prevalentSystem, Date executionTime) throws Exception {
				  return prevalentSystem.getAllNews().size();
				}});

		} finally {
			prevayler.close();

		}
		return "Number of news left: " + count;
	}

	@CrossOrigin
	@RequestMapping("/update")
	public String update(@RequestBody News news) throws Exception {
		System.out.println(news.getTitle());

		Prevayler<Root> prevayler = initPrevayler();
		try {

			prevayler.execute(new UpdateNewsTitleTransaction(news.getID(), news.getTitle()));

		} finally {
			prevayler.close();

		}
		return "news updated";
	}

	@CrossOrigin
	@RequestMapping("/delete")
	public String delete(@RequestBody News news) throws Exception {
		Prevayler<Root> prevayler = initPrevayler();
		News removed;
		try {

			removed = prevayler.execute(new DeleteNewsTransaction(news.getID()));

		} finally {
			prevayler.close();

		}
		return "News: \"" + removed.getTitle() + "\" gets removed";
	}


	private static Prevayler<Root> initPrevayler() {
		String dataPath = "/tmp";
		try {
		  return PrevaylerFactory.createPrevayler(new Root(), dataPath);
		} catch (Exception e) {
		  throw new IllegalStateException(e);
		}
	  }

}
