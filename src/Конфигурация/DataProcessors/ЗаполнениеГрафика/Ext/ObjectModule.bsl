﻿Процедура ЗаполнитьГрафик(ДатаНачала, ДатаОкончания, График) Экспорт 

	Набор = РегистрыСведений.ГрафикиРаботы.СоздатьНаборЗаписей();
	Набор.Отбор.График.Установить(График);
	Набор.Прочитать();
	
	ЧислоСекундВСутках = 86400;
	             
	Дат = ДатаНачала;
	РазностьДней = (НачалоДня(ДатаНачала) - НачалоДня(График.НачалоГрафика))/ЧислоСекундВСутках;
	
	// Массив с часами графика
	Часы = График.РабочиеЧасы.ВыгрузитьКолонку("Часы");
	ПериодГрафика = Часы.Количество();
	// Начальное смещение по графику
	Смещ =  ?(РазностьДней < 0, ПериодГрафика, 0) + (РазностьДней % ПериодГрафика);
	
	Для Индекс = 0 По Набор.Количество()-1 Цикл
		
		Запись = Набор[Индекс];
		Если Запись.Дата < ДатаНачала Тогда
		    Продолжить;
		ИначеЕсли Запись.Дата = Дат Тогда
			Запись.График	    = График;
			Запись.ЗначениеЧасы = Часы[Смещ];
			Запись.ЗначениеДни  = ?(Часы[Смещ] = 0, 0, 1);
			Дат  = Дат + ЧислоСекундВСутках;
			Смещ = (Смещ + 1) % ПериодГрафика;
		Иначе
			Пока Дат < Мин(Запись.Дата, ДатаОкончания) Цикл
				НоваяЗапись = Набор.Добавить();
				НоваяЗапись.Дата		 = Дат;
				НоваяЗапись.График 		 = График;
				НоваяЗапись.ЗначениеЧасы = Часы[Смещ];
				НоваяЗапись.ЗначениеДни  = ?(Часы[Смещ] = 0, 0, 1);
				Дат  = Дат + ЧислоСекундВСутках;
				Смещ = (Смещ + 1) % ПериодГрафика;
			КонецЦикла; 
			Если Запись.Дата > ДатаОкончания Тогда
				Прервать;
			Иначе
				Запись.График 		= График;
				Запись.ЗначениеЧасы = Часы[Смещ];
				Запись.ЗначениеДни 	= ?(Часы[Смещ] = 0, 0, 1);
			КонецЕсли;
			Дат  = Дат + ЧислоСекундВСутках;
			Смещ = (Смещ + 1) % ПериодГрафика;
		КонецЕсли;
	КонецЦикла;
	Набор.Записать();
	
	Пока Дат <= ДатаОкончания Цикл
		Запись = Набор.Добавить();
		Запись.Дата 		= Дат;
		Запись.График 		= График;
		Запись.ЗначениеЧасы = Часы[Смещ];
		Запись.ЗначениеДни 	= ?(Часы[Смещ] = 0, 0, 1);

		Дат  = Дат + ЧислоСекундВСутках;
		Смещ = (Смещ + 1) % ПериодГрафика;
	КонецЦикла; 
	Набор.Записать();
КонецПроцедуры
