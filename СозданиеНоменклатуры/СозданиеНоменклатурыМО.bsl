#Область ТехЗадание
//ТЗ Форсайт Объединение номенклатуры.

//Цель: Объединить Номенклатуру с характеристиками по принципу. Наименование=Наименование+Характеристика.

//План работ:

//1.Анализ номенклатуры
//	1.1. Выбрать всю номенклатуру с характеристиками, которая есть на остатке. 
//	1.2. Выбрать всю номенклатуру с характеристиками, по которой были движения за 2018 г.
//	1.3. Объединить и получить список всей номенклатуры(Наименование+Характеристика), для создания новой номенклатуры.

//2. Создать новую номенклатуру со всеми необхоимыми опциями. 
//2.1 Написать обработку по созданию новой номенклатуры.

//3. Перенос отсатков по Алгоритму-списать в Производство старую номенклатуру, и выпустить из Производства новую номенклатуру.
//	3.1. Написать обрабоку по созданию документов Производства. 8 часов.
//	3.2 Документами  "Производство" перенести остатки из старой номенклатуры в новую.

//4. Перенос Цен Номенклатуры алгоритму ЦенаНовойНоменклатуры=ЦенаСтарой(Номенклатура+Характеристика) 
//4.1 Создать обробатку по переносу цен номенклатуры.
//4.2 Скопировать Цены старой номенклатуры в новую
//	
//4.В открытых заказах поменять Старую Номенклатуру на новую.

//5.Тестирование и устранение возникших ошибок.
//	5.1. Удалить возможные Дубли, проверить корректность остатков.
//	5.2. Протестировать работоспособность Алгоритмов и бизнес процессов, с Новой номенклатурой. 
//	5.3. Устранить выявленные ошибки.

//6. Настройка Обмена данными между УНФ и БУХ 3.0
//	6.1 Натсроить 1 час
//	6.3 Сопоставить Справочники УНФ и БУХ.
//потребуется времени на сопоставление. Далее решим выполняют своими силами или программисты.
//	6.4 Устранить при необходимости имеющиеся дубли.
//	6.3 При необходимости скорректировать правила обмена. 

//7. Повторить все  в Рабочей базе.

//8. Тех поддержка на первых этапах после Выполненных работ. 

//Примечание: Выполнить перенос в живой базе после закрытия периода, Желательно Квартала или года. для корректного расчета себестоимости, 
//Валовой прибыли и т.д.  

//По предварительному анализу, новой номенклатуры в УНФ будет создано около 3500 единиц. На Данный момент в БП 19277.
#КонецОбласти



#Область Процедуры_Создания
Процедура СоздатьНоменклатуру(ТЗНоменклатура) экспорт
	//Создает новую номенклатуру Наименование+Характеристика. копирует доп реквизиты если они присутствуют в исходной.
	//Присваеват категорию и вид из старой номенклатуры.
	РодительДляНоменклатуры=Справочники.Номенклатура.НайтиПоНаименованию("Новая номенклатура");
	Для каждого СтрокаТЗ Из ТЗНоменклатура Цикл
	
		//СоздаемНоменклатуру
		
		Если Справочники.Номенклатура.НайтиПоНаименованию(СтрокаТЗ.НоваяНоменклатура)<>Справочники.Номенклатура.ПустаяСсылка() тогда 
			//Сообщить(СтрокаТЗ.НоваяНоменклатура+" Уже Существует");
			Продолжить;
		КонецЕсли;
	Попытка
		НовНоменклатура=Справочники.Номенклатура.СоздатьЭлемент();
		////Если Не ПустаяСтрока(СтрокаТЗ.Ариткул) тогда
		////Номенклатура.Артикул=СтрокаТз.Наименование;
		////КонецЕсли;
		НовНоменклатура.Наименование=Лев(СтрокаТЗ.НоваяНоменклатура, 100);
		НовНоменклатура.НаименованиеПолное=СокрЛП(СтрокаТЗ.НоваяНоменклатура);
		СтараяНоменклатура=ПолучитьСтаруюНоменклатуру(СтрокаТЗ.Номенклатура, СтрокаТЗ.Характеристика);
		Если СтараяНоменклатура=Неопределено тогда
		 Сообщить( "Комбинация "+ СтрокаТЗ.НоваяНоменклатура+ " В базе не найдена.");
		 Продолжить;
		КонецЕсли;
		НовНоменклатура.ТипНоменклатуры=СтараяНоменклатура.Номенклатура.ТипНоменклатуры;
		НовНоменклатура.ЕдиницаИзмерения=СтараяНоменклатура.Номенклатура.ЕдиницаИзмерения.ссылка;
		НовНоменклатура.Склад=СтараяНоменклатура.Номенклатура.Склад.ссылка;
		НовНоменклатура.ВидСтавкиНДС=СтараяНоменклатура.Номенклатура.ВидСтавкиНДС;
		НовНоменклатура.КатегорияНоменклатуры=СтараяНоменклатура.Номенклатура.КатегорияНоменклатуры;
		//НовНоменклатура.Родитель=СтараяНоменклатура.Номенклатура.Родитель;
		НовНоменклатура.Родитель=РодительДляНоменклатуры;
		НовНоменклатура.СпособПополнения=СтараяНоменклатура.Номенклатура.СпособПополнения;
		//НовНоменклатура.Код=    /////// ????????????????????///Каким образом будет формироваться
		НовНоменклатура.СчетУчетаЗапасов=СтараяНоменклатура.Номенклатура.СчетУчетаЗапасов;
		НовНоменклатура.СчетУчетаЗатрат=СтараяНоменклатура.Номенклатура.СчетУчетаЗатрат;
		НовНоменклатура.НаправлениеДеятельности=СтараяНоменклатура.Номенклатура.НаправлениеДеятельности;
		НовНоменклатура.ФайлКартинки=СтараяНоменклатура.Номенклатура.ФайлКартинки;
		НовНоменклатура.МетодОценки=СтараяНоменклатура.Номенклатура.МетодОценки;      //На Форме Элемента "Способ списания"
		НовНоменклатура.СрокИсполненияЗаказа=СтараяНоменклатура.Номенклатура.СрокИсполненияЗаказа;
		НовНоменклатура.СрокПополнения=СтараяНоменклатура.Номенклатура.СрокПополнения;
	    //Записываем Доп реквизиты.
	    ДопРеквизитPN = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("PN_NEW_AiG");
	    ЕстьСтроки = НовНоменклатура.ДополнительныеРеквизиты.НайтиСтроки(Новый Структура("Свойство", ДопРеквизитPN));
	    Если ЕстьСтроки.Количество() = 0 Тогда
	  СтрокаТЧ = НовНоменклатура.ДополнительныеРеквизиты.Добавить();
	  СтрокаТЧ.Свойство = ДопРеквизитPN;
	    Иначе
	  СтрокаТЧ = ЕстьСтроки[0];
	    КонецЕсли;
	    СТрокаТЧ.Значение = СокрЛП(СтрокаТЗ.PN);
		//СТрокаТЧ.Записать();
		НовНоменклатура.Записать();
		
	Исключение
		Сообщить(СтрокаТЗ.НоваяНоменклатура+" Не создана."+ОписаниеОшибки());
	КонецПопытки;
	КонецЦикла;
	
	
КонецПроцедуры

Функция ПолучитьОстаткиНоменклатуры(НомеклатураОст, ХарактеристикаОст, СтруктурнаяЕдиница);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗапасыОстатки.Номенклатура КАК Номенклатура,
		|	ЗапасыОстатки.Характеристика КАК Характеристика,
		|	ЗапасыОстатки.КоличествоОстаток КАК Количество,
		|	ЗапасыОстатки.СуммаОстаток КАК СуммаОстаток,
		|	ЗапасыОстатки.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ЗапасыНаСкладахОстатки.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|	ЗапасыНаСкладахОстатки.КоличествоОстаток КАК КоличествоИзЗапасыНаСкладах,
		|	ЗапасыНаСкладахОстатки.Организация КАК Организация
		|ИЗ
		|	РегистрНакопления.Запасы.Остатки(
		|			&КонецПериода,
		|			Номенклатура.Наименование = &Номенклатура
		|				И Характеристика.Наименование = &Характеристика
		|				И СтруктурнаяЕдиница = &СтруктурнаяЕдиница) КАК ЗапасыОстатки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ЗапасыНаСкладах.Остатки(
		|				&КонецПериода,
		|				Номенклатура.Наименование = &Номенклатура
		|					И Характеристика.Наименование = &Характеристика
		|					И СтруктурнаяЕдиница = &СтруктурнаяЕдиница) КАК ЗапасыНаСкладахОстатки
		|		ПО ЗапасыОстатки.Организация = ЗапасыНаСкладахОстатки.Организация
		|			И ЗапасыОстатки.Номенклатура = ЗапасыНаСкладахОстатки.Номенклатура
		|			И ЗапасыОстатки.Характеристика = ЗапасыНаСкладахОстатки.Характеристика
		|ГДЕ
		|	ЗапасыОстатки.КоличествоОстаток > 0";
	Запрос.УстановитьПараметр("Номенклатура",НомеклатураОст);
	Запрос.УстановитьПараметр("Характеристика",ХарактеристикаОст);
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница",СтруктурнаяЕдиница);
	
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(ТекущаяДата()));
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Если РезультатЗапроса.Количество()>0  Тогда
	  возврат РезультатЗапроса;	
	КонецЕсли; 
	//ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	//Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	//	// Вставить обработку выборки ВыборкаДетальныеЗаписи
	//КонецЦикла;
	 возврат Неопределено;
КонецФункции // ПолучитьОстаткиНоменклатуры()
 
Функция ПолучитьСтаруюНоменклатуру(Наименование, Характеристика);
	
	//Возвращает Табличную часть найденной номенклатуры
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Номенклатура.Ссылка КАК Номенклатура,
		|	ХарактеристикиНоменклатуры.Ссылка КАК Характеристика
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
		|		ПО (ХарактеристикиНоменклатуры.Владелец.Ссылка = Номенклатура.Ссылка)
		|ГДЕ
		|	Номенклатура.Наименование = &НаименНоменклатуры
	//	|	И ХарактеристикиНоменклатуры.Наименование = &НаименХарактеристики
		|";
	
	Запрос.УстановитьПараметр("НаименНоменклатуры", СокрЛП(СтрЗаменить(Наименование,",","")));
	//Запрос.УстановитьПараметр("НаименХарактеристики", СокрЛП(Характеристика));
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Если РезультатЗапроса.Количество()<>0 тогда 
	ВыборкаДетальныеЗаписи = РезультатЗапроса[0];
	Иначе 
	  Возврат Неопределено;
	КонецЕсли;
	Возврат ВыборкаДетальныеЗаписи;

конецфункции

Функция ПолучитьНовуюНоменклатуру()
	
	ГруппаНоменклатуры = Справочники.Номенклатура.НайтиПоНаименованию("Новая номенклатура");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Номенклатура.Ссылка КАК Номенклатура,
		|	Номенклатура.Представление КАК ПредставлениеНоменклатуры
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.Ссылка В ИЕРАРХИИ(&ГруппаНоменклатуры)";
	
	Запрос.УстановитьПараметр("ГруппаНоменклатуры", ГруппаНоменклатуры);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Возврат РезультатЗапроса;
КонецФункции

Процедура СписатьВПроизводство(ТЗНоменклатура) экспорт
	//Процедура Списывают в производство  номенклатуру из талицы соответсвтий по которой есть остатки.
	//Выпускает из производства новую номенклатру созданную процедурой СоздатьНоменклатуру()
	ТЗНоваяНоменклатура=ПолучитьНовуюНоменклатуру();
	массивСтрукЕд= новый массив;
	массивСтрукЕд.Добавить(Справочники.СтруктурныеЕдиницы.НайтиПоНаименованию("DigitalRazor"));
	массивСтрукЕд.Добавить(Справочники.СтруктурныеЕдиницы.НайтиПоНаименованию("EVO"));
	массивСтрукЕд.Добавить(Справочники.СтруктурныеЕдиницы.НайтиПоНаименованию("Тестовый склад"));
	массивСтрукЕд.Добавить(Справочники.СтруктурныеЕдиницы.НайтиПоНаименованию("Гарантийный склад"));
	массивСтрукЕд.Добавить(Справочники.СтруктурныеЕдиницы.НайтиПоНаименованию("Баланс фирмы"));
	массивСтрукЕд.Добавить(Справочники.СтруктурныеЕдиницы.НайтиПоНаименованию("Основной склад"));	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СтрукЕд",массивСтрукЕд);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СтруктурныеЕдиницы.Ссылка КАК СтруктурнаяЕдиница,
		|	СтруктурныеЕдиницы.Организация КАК Организация
		|ИЗ
		|	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
		|ГДЕ
		|	СтруктурныеЕдиницы.Ссылка В (&СтрукЕд)";
	
	ТЗСтруктурнаяЕдиница = Запрос.Выполнить().Выгрузить();
	
	Для каждого СтрокаСтрутурнаяЕд Из ТЗСтруктурнаяЕдиница Цикл 
		
		ДокПроизводсто=Документы.СборкаЗапасов.СоздатьДокумент();
		ДокПроизводсто.Дата=ТекущаяДата();
		ДокПроизводсто.ВидОперации=Перечисления.ВидыОперацийСборкаЗапасов.Сборка;
		ДокПроизводсто.Организация=СтрокаСтрутурнаяЕд.Организация;
		ДокПроизводсто.СтруктурнаяЕдиницаЗапасов=СтрокаСтрутурнаяЕд.СтруктурнаяЕдиница;
		ДокПроизводсто.СтруктурнаяЕдиница=СтрокаСтрутурнаяЕд.СтруктурнаяЕдиница;
		ДокПроизводсто.СтруктурнаяЕдиницаПродукции=СтрокаСтрутурнаяЕд.СтруктурнаяЕдиница;
		ДокПроизводсто.РучноеРаспределение=Истина;
		ТчПродукция=ДокПроизводсто.Продукция;
		ТчЗапасы=ДокПроизводсто.Запасы;
		ТЧРаспределениеЗапасов = ДокПроизводсто.РаспределениеЗапасов;
		КлючСвязиРаспределения=1;
		Для каждого СтрокаНовНоменклатура Из Номенклатура Цикл   //Заполняем табличную часть Продукция.
			
			СтрокаОстаток=ПолучитьОстаткиНоменклатуры(СтрЗаменить(СтрокаНовНоменклатура.Номенклатура,",",""),СтрокаНовНоменклатура.Характеристика, СтрокаСтрутурнаяЕд.СтруктурнаяЕдиница); 
			НоваяНоменклатура=ТЗНоваяНоменклатура.Найти(СтрокаНовНоменклатура.новаяноменклатура);
			Если СтрокаОстаток<>Неопределено и НоваяНоменклатура<>Неопределено Тогда
				Попытка
					НовСтрТчПродукция=ТчПродукция.Добавить();
					НовСтрТЧЗапасы=ТчЗапасы.Добавить();
					НовСтрРаспределениеЗапасов=ТЧРаспределениеЗапасов.Добавить();
					НовСтрТчПродукция.Номенклатура=НоваяНоменклатура.Номенклатура;
					НовСтрТчПродукция.ЕдиницаИзмерения=СтрокаОстаток[0].ЕдиницаИзмерения;
					НовСтрТчПродукция.Количество=СтрокаОстаток[0].Количество;
					
					НовСтрТЧЗапасы.Номенклатура=СтрокаОстаток[0].Номенклатура;
					НовСтрТЧЗапасы.Характеристика=СтрокаОстаток[0].Характеристика;
					НовСтрТЧЗапасы.Количество=СтрокаОстаток[0].Количество;
					НовСтрТЧЗапасы.ЕдиницаИзмерения=СтрокаОстаток[0].ЕдиницаИзмерения;
					
					НовСтрРаспределениеЗапасов.КлючСвязиПродукция=КлючСвязиРаспределения;
					НовСтрРаспределениеЗапасов.Номенклатура=СтрокаОстаток[0].Номенклатура;
					НовСтрРаспределениеЗапасов.Характеристика=СтрокаОстаток[0].Характеристика;
					НовСтрРаспределениеЗапасов.Количество=СтрокаОстаток[0].Количество;
					НовСтрРаспределениеЗапасов.ЕдиницаИзмерения=СтрокаОстаток[0].ЕдиницаИзмерения;
					КлючСвязиРаспределения=КлючСвязиРаспределения+1;
					
				исключение
					Сообщить("Номенлатура не найдена:" +СтрокаНовНоменклатура.новаяноменклатура );
				КонецПопытки;
			КонецЕсли;  
				
		КонецЦикла;
		ДокПроизводсто.Записать(РежимЗаписиДокумента.Запись);
	КонецЦикла;
КонецПроцедуры

Процедура УстановитьЦеныНоменклатуры(ТЗНоменклатура) экспорт
	//Процедура устанвливает цены новой номенклатуре
	//Цены берутся из Регистра "Цены Номенклатуры Контрагентов"	
КонецПроцедуры

Функция ЦеныСтаройНоменклатуры(Наименование, Характеристика)
	
	  	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЦеныНоменклатурыКонтрагентовСрезПоследних.ВидЦенКонтрагента КАК ВидЦенКонтрагента,
		|	ЦеныНоменклатурыКонтрагентовСрезПоследних.Номенклатура КАК Номенклатура,
		|	ЦеныНоменклатурыКонтрагентовСрезПоследних.Характеристика КАК Характеристика,
		|	ЦеныНоменклатурыКонтрагентовСрезПоследних.Цена КАК Цена,
		|	ЦеныНоменклатурыКонтрагентовСрезПоследних.Актуальность КАК Актуальность,
		|	ЦеныНоменклатурыКонтрагентовСрезПоследних.ЕдиницаИзмерения КАК ЕдиницаИзмерения
		|ИЗ
		|	РегистрСведений.ЦеныНоменклатурыКонтрагентов.СрезПоследних(&Период, Номенклатура.Наименование = &НаименНоменклатуры) КАК ЦеныНоменклатурыКонтрагентовСрезПоследних";
	
	Запрос.УстановитьПараметр("НаименНоменклатуры", Наименование);
	Запрос.УстановитьПараметр("Период", КонецДня(ТекущаяДата()));
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	возврат РезультатЗапроса;
	



КонецФункции
 
Процедура СкопироватьШтрихКоды(ТЗНоменклатура) экспорт
	//Копирует штрихкоды из старой номенклатуры в новую	
	
КонецПроцедуры

Процедура СкопироватьУправленияЗАпасами(ТЗНоменклатура)
//Копирует управление запасами Номенклатуры из Регистра "Управление Запасами"	
	
КонецПроцедуры

Процедура СкопироватьПоставщиков(ТЗНоменклатура)
	//Регистр "Поставщики"
	//Узнать нужны ли эти данные 
	
КонецПроцедуры

Процедура СкопироватьКодыТоваровSKU(ТЗНоменклатура)
	//Регистр "КодыТоваровSKU"
	//Копирует КодыТоваров SKU 
КонецПроцедуры
#КонецОбласти
