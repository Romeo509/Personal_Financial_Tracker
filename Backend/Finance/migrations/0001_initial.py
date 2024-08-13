# Generated by Django 4.1.13 on 2024-08-13 18:55

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('Account', '0002_alter_user_email_alter_user_first_name_and_more'),
    ]

    operations = [
        migrations.CreateModel(
            name='Transaction',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('transaction', models.TextField()),
                ('amount', models.FloatField()),
                ('created_at', models.DateTimeField()),
                ('deadline', models.DateTimeField()),
            ],
        ),
        migrations.CreateModel(
            name='Account',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('balance', models.FloatField()),
                ('created_at', models.DateTimeField()),
                ('username', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='Account.user')),
            ],
        ),
    ]
