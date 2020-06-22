package com.example.springboot;

import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;
import java.util.stream.Collectors;

import com.example.springboot.entity.News;
import com.example.springboot.entity.Root;
import com.example.springboot.operator.CreateNewsTransaction;
import com.example.springboot.operator.DeleteNewsTransaction;
import com.example.springboot.operator.GetNews;
import com.example.springboot.operator.UpdateNewsTitleTransaction;
import org.prevayler.Query;

import org.prevayler.Prevayler;
import org.prevayler.PrevaylerFactory;
import org.prevayler.Transaction;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;

@RestController
public class HelloController {

	@RequestMapping("/")
	public String index() {
		return "Greetings from Spring Boot!";
	}

	@RequestMapping("/create")
	public String write() throws Exception {
		Prevayler<Root> prevayler = initPrevayler();
		try {

			final News news = prevayler.execute(new CreateNewsTransaction(UUID.randomUUID().toString()));

			final String titleOfNews = "test test";

			prevayler.execute(new UpdateNewsTitleTransaction(news.getID(), titleOfNews));
			System.out.println("news.getTitle(): " + news.getTitle());
			// assertEquals(titleOfNews, news.getTitle());

			// News queryResponse = prevayler.execute(new GetNews(news.getID()));
			// System.out.println("news.getTitle(): " + news.getTitle());
			// assertSame("person and queryResponse are supposed to be the same object instance!", news, queryResponse);

			// News removed = prevayler.execute(new DeleteNewsTransaction(news.getID()));
			// assertSame("person and removed are supposed to be the same object instance!", news, removed);

			// assertTrue("There are not supposed to be any persons in the root at this point!",
			// 		prevayler.execute(new Query<Root, Boolean>() {
			// 			private static final long serialVersionUID = -96319481126700055L;

			// 			public Boolean query(Root prevalentSystem, Date executionTime) throws Exception {
			// 				return prevalentSystem.getAllNews().isEmpty();
			// 			}
			// 		}));

		} finally {
			prevayler.close();

		}
		return "create a news!";
	}

	@RequestMapping("/select/{id}")
	public String select(@PathVariable("id") String id) throws Exception {
		Prevayler<Root> prevayler = initPrevayler();
		System.out.println(id);
		News queryResponse;
		try {

			queryResponse = prevayler.execute(new GetNews(id));

		} finally {
			prevayler.close();

		}
		if (queryResponse != null) {
			return queryResponse.getTitle();
		}
		return "cannot find news!";
	}

	@RequestMapping("/select")
	public String select() throws Exception {
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
			return allNews.keySet().stream()
			.map(key -> "id: " + key + ", title: " + ((News)allNews.get(key)).getTitle())
			.collect(Collectors.joining("</p><p>","<p>","</p>"));

		}
		return "Cannot find news!";
	}

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

	@RequestMapping("/update")
	public String update(News news) throws Exception {
		Prevayler<Root> prevayler = initPrevayler();
		try {

			prevayler.execute(new UpdateNewsTitleTransaction(news.getID(), news.getTitle()));

		} finally {
			prevayler.close();

		}
		return "news updated";
	}

	@RequestMapping("/delete")
	public String delete(News news) throws Exception {
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
