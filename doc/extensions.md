## Extensions

### Tier 1 - Least Difficult
```
As an admin     
When I visit an admin invoices index page
I see each of the invoices statuses
I also have the ability to manage all invoice statuses on the page at the same time.
I can change multiple statuses via a dropdown list or checkboxes.
When I click the update button, I see the changes reflected on the index page for each invoice I updated.
```

```
As an admin, merchant, or visitor
On all pages that list all merchants, invoices, or items
I see a button to sort the list alphabetically, and I see a button to sort by most recent date.
When I click these buttons, the list is updated accordingly.
```

Implement a consistent look and feel throughout your site with reusable styles.

You could use a framework for this such as: [Bootstrap](https://getbootstrap.com)

[Bootstrap Ruby Gem](https://github.com/twbs/bootstrap-rubygem)

Or, you could create custom styles!

### Tier 2 - Difficult

#### Filters

```
As an admin, I have the ability to see all items on the site
I can also filter the results of this page by any item attribute

What this could look like:
Search boxes for both name and description
Check boxes for merchant names
Greater than, less than, and equal to options for unit price
Greater than, less than, and equal to options for created at and updated at
```

### Tier 3- Most Difficult

#### Auth - Implement authentication and authorization for admins and/or merchant users

[Authentication Lesson Plan](https://backend.turing.io/module2/lessons/authentication)

[Authorization Lesson Plan](https://backend.turing.io/module2/lessons/authorization]

[Sessions](https://guides.rubyonrails.org/v5.2/action_controller_overview.html#session)


#### Cart - Implement the functionality for visitors to start adding items to their cart

[Cart Lesson Plan](https://backend.turing.io/module2/lessons/cart_implementation)

#### Research Action Cable and implement chat functionality on the site.

[Action Cable](https://guides.rubyonrails.org/v5.2/action_cable_overview.html)

#### Come Up With Your Own Feature

....

## Bulk Discounts Extensions

```
When an invoice is pending, a merchant should not be able to delete or edit a bulk discount that applies to any of their items on that invoice.
When an Admin marks an invoice as “completed”, then the discount percentage should be stored on the invoice item record so that it can be referenced later
Merchants should not be able to create/edit bulk discounts if they already have a discount in the system that would prevent the new discount from being applied (see example 4)
Holiday Discount Extensions
Create a Holiday Discount
```

```
As a merchant,
when I visit the discounts index page,
In the Holiday Discounts section, I see a `create discount` button next to each of the 3 upcoming holidays.
When I click on the button I am taken to a new discount form that has the form fields auto populated with the following:

Discount name: <name of holiday> discount
Percentage Discount: 30
Quantity Threshold: 2

I can leave the information as is, or modify it before saving.
I should be redirected to the discounts index page where I see the newly created discount added to the list of discounts.
View a Holiday Discount
```

```
As a merchant (if I have created a holiday discount for a specific holiday),
when I visit the discount index page,
within the `Upcoming Holidays` section I should not see the button to 'create a discount' next to that holiday,
instead I should see a `view discount` link.
When I click the link I am taken to the discount show page for that holiday discount.
```
